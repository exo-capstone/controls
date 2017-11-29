clear all; clc;
load('systemid.mat');
%% Measured parameters
% m = 256;    % kg
% b = 1250;   % N*s/m
k = 549360; % N/m
mk = 269.82;
beff = 1196.8508;
% N = 300;
Beta = 825.6288;

% % UT-SEA force control parameters
% kp = 0.05;  % A/N
% f_kd = 100; % Hz
% CL_damp_ratio = 0.9;    % no units
% f_q = 40;   % Hz
% Beta = 219; % N/A
% mk = 360;   % kg
% beff = 2200;    % Ns/m
% k = 350000; % N/m
% kd = (2*CL_damp_ratio*sqrt(mk*k*(1+Beta*kp))-beff)/(k*Beta);    %8.825e-04
%% Chosen parameters
CL_damp_ratio = .9;   % no units
kp = 0.05;  % A/N
kd = (2*CL_damp_ratio*sqrt(mk*k*(1+Beta*kp))-beff)/(k*Beta);

% Mhat = mk;
% Bhat = beff + k*Beta*kd;
% Khat = k*(1+Beta*kp);
% damping_ratio = Bhat/(2*sqrt(Mhat*Khat));
%% Force Control (Ideal)
% Open Loop
% Plant
P=sys;
P.u = 'i';
P.y = 'fk';
% Controller
PD = tf([kd, kp],[1]);
PD.u = 'e';
PD.y = 'u';
% For feed forward
B = tf([1/Beta],[1]);
B.u = 'fr';
B.y = 'frb';

% Connection definitions
S1 = sumblk('e=fr');
S2 = sumblk('i=u+frb');
inp = {'fr'};
outp = {'fk'};

Gol = tf(connect(P,PD,B,S1,S2, inp, outp));
% figure
% bode(Gol)
% figure
% step(Gol)

% Closed Loop
S1_cl = sumblk('e=fr-fk');
Pc = tf(connect(P,PD,B,S1_cl ,S2, inp, outp));
% figure
% bode(Pc)
% figure
% step(Pc)

%% Create Disturbance and Noise
% Declare disturbance and noise as inputs and add to system blocks
inp_nd = {'fr';'n';'d'};
S1_nd = sumblk('e=fr-fk_fdbk');
noise_block = sumblk('fk_fdbk=fk+n');    % add noise to feedback
S2_nd = sumblk('i=u+frb+d');    % add disturbance between plant and controller
Pc_nd = tf(connect(P,PD,B,S1_nd, noise_block ,S2_nd, inp_nd, outp));

% Create discrete time steps to apply noise and disturbance
t = 0:.01:12;
% noise in the feedback signal
noise = 0.1*randn(numel(t),1);

% Disturbance between controller and plant
dist = ones(numel(t),1);
dist(1:floor(numel(t)/2)) = 0.5;    % provides 2 different disturbances

%% Disturbance Observer
wc = 1;
Q = tf([1],[1/wc^2, 1.4142/wc, 1]);

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

%% Test Controller

% Plot noise and disturbance for reference
figure
plot(t, noise,'r', t, dist, 'b');
% hold on
legend('Noise', 'Disturbance');
xlabel('Time');

% Simulate Controller with given inputs
Fd = zeros(numel(t),1);
Fk = lsim(SYS, [Fd,noise, dist], t);

figure
plot(t, Fk, 'LineWidth', 2);







