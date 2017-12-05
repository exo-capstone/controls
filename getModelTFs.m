function [ SYS, Gol, Pc, Pc_nd ] = getModelTFs(P, C, B)
% Uses model outlined in Nick Paine's thesis (below) to return the open 
% loop, closed loop (ideal), closed loop (w/noise and dist), and closed 
% loop w/DOB transfer functions given plant, controller, and feedforward TFs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                         d
%               -----------[ B ]-----     |
%               |                   |+    v
% fd-->--+o--fr----+o--e---[ C ]---+o--i--o--[ P ]----->fk
%        -|      |  |-                               |   
%         |      |  ---------------------------------o<--n
%         |      |                          |
%         |      ---[ Q ]--o--[ P^-1*Q ]-----
%         |               -|+
%         ------------------        
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define Plant input/output
P.u = 'i';
P.y = 'fk';
% Define Controller input/output
C.u = 'e';
C.y = 'u';
% Define Feedforward input/output
B.u = 'fr';
B.y = 'frb';

% Connection definitions
S1 = sumblk('e=fr');
S2 = sumblk('i=u+frb');
inp = {'fr'};
outp = {'fk'};

% Open loop transfer function
Gol = tf(connect(P,C,B,S1,S2, inp, outp));

%% Closed Loop
S1_cl = sumblk('e=fr-fk');
Pc = tf(connect(P,C,B,S1_cl ,S2, inp, outp));

% For checking against the expected closed loop (only relevant for v1 controller)
% Pc_check = tf([k*beta*kd, k*(1 + beta*kp)], [mk, b_eff + k*beta*kd, k*(1 + beta*kp)]);

%% Create Disturbance and Noise
% Declare disturbance and noise as inputs and add to system blocks
inp_nd = {'fr';'n';'d'};
S1_nd = sumblk('e=fr-fk_fdbk');
noise_block = sumblk('fk_fdbk=fk+n');       % add noise to feedback
S2_nd = sumblk('i=u+frb+d');                % add disturbance between plant and controller
Pc_nd = tf(connect(P,C,B,S1_nd, noise_block ,S2_nd, inp_nd, outp));

%% Disturbance Observer
wn = max(damp(Pc)); % 293.3863
Q = tf([1],[1/wn^2, 1.4142/wn, 1]);

BL = Q;
BL.u = 'fr';
BL.y = 'q1';
BR = Q/Pc;
BR.u = 'fk_fdbk';
BR.y = 'q2';
S3 = sumblk('dob=q2-q1');
% noise_block accounts for 'fk_fdbk=fk+n'

inp_dob = {'fr';'fk';'n'};
out_dob = {'dob'};

DOB = tf(connect(BL,BR,S3,noise_block, inp_dob, out_dob));

%% Combine Pc and DOB
inp_sys = {'fd'; 'n'; 'd'};
out_sys = {'fk'};

S4 = sumblk('fr=fd-dob');
SYS = tf(connect(Pc_nd,DOB,S4,inp_sys,out_sys));
end



