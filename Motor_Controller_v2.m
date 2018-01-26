clear all; clc; close all;
load('SEA.mat');

% % UT-SEA force control parameters
% kp = 0.05;  % A/N
% f_kd = 100; % Hz
% CL_damp_ratio = 0.9;    % no units
% f_q = 40;   % Hz
% beta = 219; % N/A
% mk = 360;   % kg
% b_eff = 2200;    % Ns/m
% k = 350000; % N/m
% kd = (2*CL_damp_ratio*sqrt(mk*k*(1+beta*kp))-b_eff)/(k*beta);    %8.825e-04
%% Chosen parameters
CL_damp_ratio = .9;   % no units
kp = 0.05;  % A/N
kd = (2*CL_damp_ratio*sqrt(mk*k*(1+beta*kp))-b_eff)/(k*beta);

%% Force Control (Ideal)
% Open Loop

% Plant
P = SEA;
% Controller
PD = tf([kd, kp],[1]);
%H = integralboost(293); % chosen b/c of Plant's natural frequency
f_c = 100;
f_sample = 1000;
[b,a] = butter(2,f_c/(f_sample/2));
C = PD;
% Feedforward
B = tf([1/beta],[1]);

[SYS, L, Gol, Pc, Pc_nd, DOB] = getModelTFs_noFF(P,C);
[SYS_orig, L_orig, Gol_orig, Pc_orig, Pc_nd_orig, ~] = getModelTFs(P,PD,B);

SYS = minreal(SYS)
L = minreal(L)

%% Open Loop Analysis
S = feedback([1],[L]);
T = feedback([L],[1]);

figure
subplot(2,1,1)
bodemag(L,'-b', S,'-g', T,'-r')
legend('new L', 'new S', 'new T')
title('Test Controller Bode Diagram')

S_orig = feedback([1],[L_orig]);
T_orig = feedback([L_orig],[1]);

subplot(2,1,2)
bodemag(L_orig,'b-', S_orig, 'g-',T_orig,'r-')
legend('original L', 'original S', 'original T')
title('Original Controller Bode Diagram')
% Open loop characteristics

c1_chars=assessL(L)
c2_chars=assessL(L_orig)

%% Create Noise/Disturbance
% Create discrete time steps to apply noise and disturbance
t = 0:.01:12;
% noise in the feedback signal
noise = 0.1*randn(numel(t),1);

% Disturbance between controller and plant
dist = ones(numel(t),1);
dist(1:floor(numel(t)/2)) = 0.5;    % provides 2 different disturbances

%% Closed Loop w/DOB Analysis

% Simulate Controller with given inputs
Fd = zeros(numel(t),1);

% Plot input, noise and disturbance for reference
% figure
% plot(t, Fd, 'k', t, noise,'r', t, dist, 'g');
% legend('Input','Noise', 'Disturbance');
% xlabel('Time');


Fk = lsim(SYS, [Fd,noise, dist], t);
Fk_orig = lsim(SYS_orig, [Fd,noise,dist],t);

figure
subplot(2,1,1)
plot(t, Fk, 'LineWidth', 2);
title('Test Controller')

subplot(2,1,2)
plot(t, Fk_orig, 'LineWidth',2);
title('Original PD Controller')

%% Convert from continuous to discrete time
Ts = 1/1000; % assume sampling rate of 1 kHz
% C_discrete = c2d(C,Ts);
Q_discrete = c2d(DOB(1,1),Ts);
PcInverseQ_discrete = c2d(DOB(1,2),Ts);
PD_discrete = c2d(PD,Ts,'tustin');

[Q_num, Q_den] = tfdata(Q_discrete);
[PcQ_num, PcQ_den] = tfdata(PcInverseQ_discrete);
[PD_num, PD_den] = tfdata(PD_discrete); 