clear all; clc;
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
H = integralboost(293);
C = PD*H;
% Feedforward
B = tf([1/beta],[1]);

[SYS, Gol, Pc, Pc_nd] = getModelTFs(P,C,B);
[SYS_2, Gol_2, Pc_2, Pc_nd_2] = getModelTFs(P,PD,B);


%% Open Loop Analysis
sens_func = feedback([1],[Gol]);
comp_sens_func = feedback([Gol],[1]);

functions = {Gol; sens_func; comp_sens_func};
bodemag(functions{:})
legend('L', 'S', 'T')

%% Create Noise/Disturbance
% Create discrete time steps to apply noise and disturbance
t = 0:.01:12;
% noise in the feedback signal
noise = 0.1*randn(numel(t),1);

% Disturbance between controller and plant
dist = ones(numel(t),1);
dist(1:floor(numel(t)/2)) = 0.5;    % provides 2 different disturbances

%% Closed Loop w/DOB Analysis
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





