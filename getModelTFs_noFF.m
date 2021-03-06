function [ SYS, L, Gol, Pc, Pc_nd, DOB, Q, PinvQ] = getModelTFs_noFF(P, C)
% Uses model outlined in Nick Paine's thesis (below) to return the open 
% loop, closed loop (ideal), closed loop (w/noise and dist), and closed 
% loop w/DOB transfer functions given plant, controller, and feedforward TFs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                      d
%                                      |
%                                      v
% fd-->--+o--fr----+o--e---[ C ]--i----o--id-[ P ]----->fk
%        -|      |  |-                             |   
%         |      |  -------------------------------o<--n
%         |      |                          |fk_fdbk
%         |      ---[ Q ]--o--[ P^-1*Q ]-----
%         |               -|+
%         ------------------        
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define Plant input/output
P.u = 'id';
P.y = 'fk';
% Define Controller input/output
C.u = 'e';
C.y = 'i';


% Connection definitions
S1 = sumblk('e=fr');
S2 = sumblk('id=i');
inp = {'fr'};
outp = {'fk';'i'};

% Open loop transfer function without feed forward (just P and C)
L = P*C;

% Open loop transfer function with feed forward
Gol = tf(connect(P,C,S1,S2, inp, outp));

%% Closed Loop
S1_cl = sumblk('e=fr-fk');
Pc = tf(connect(P,C,S1_cl,S2, inp, outp));

% For checking against the expected closed loop (only relevant for v1 controller)
% Pc_check = tf([k*beta*kd, k*(1 + beta*kp)], [mk, b_eff + k*beta*kd, k*(1 + beta*kp)]);

%% Create Disturbance and Noise
% Declare disturbance and noise as inputs and add to system blocks
inp_nd = {'fr';'n';'d'};
S1_nd = sumblk('e=fr-fk_fdbk');
noise_block = sumblk('fk_fdbk=fk+n');       % add noise to feedback
S2_nd = sumblk('id=i+d');                % add disturbance between plant and controller
outp_nd = {'fk';'i'};
Pc_nd = tf(connect(P,C,S1_nd, noise_block ,S2_nd, inp_nd, outp_nd));

%% Disturbance Observer
wn = max(damp(Pc)); % 293.3863
Q = tf(1,[1/wn^2, 1.4142/wn, 1]);

Q = Q;
Q.u = 'fr';
Q.y = 'q1';
%<<<<<<< HEAD
%=======
%BR = minreal(Q/Pc(1,1));
PinvQ = Q/Pc(1,1);
%>>>>>>> d193c6fac89ca8f4efbde9121b608bf0f00ba5c7
PinvQ.u = 'fk_fdbk';
PinvQ.y = 'q2';
S3 = sumblk('dob=q2-q1');
% noise_block accounts for 'fk_fdbk=fk+n'

inp_dob = {'fr';'fk';'n'};
out_dob = {'dob'};

DOB = tf(connect(Q,PinvQ,S3,noise_block, inp_dob, out_dob));

%% Combine Pc and DOB
inp_sys = {'fd'; 'n'; 'd'};
out_sys = {'fk'};

S4 = sumblk('fr=fd-dob');
SYS = tf(connect(Pc_nd,DOB,S4,inp_sys,out_sys));
SYS = minreal(SYS);

end



