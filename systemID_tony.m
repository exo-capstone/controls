clear all; close all; clc;
load('right_knee_open_loop_exp_chirp.mat');
input = right_knee_open_loop_exp_chirp.input;
output = right_knee_open_loop_exp_chirp.output;

% Centers output signal to zero
output = output - output(1);

% Spring constant = 549360 N/m
% Encoder angle to spring deflection= 0.000027707 m/degrees
% F = -kx
k = 549360; 
output = -output * 0.000027707 * k;

% Sampling frequency Fs = 1 kHz
Fs = 1000;
Ts = 1/Fs;
N = length(input);
t = Ts * linspace(0,N-1,N);

% Plot input and output data
f1 = figure;
subplot(2,1,1)
plot(t,input);
title('Motor current versus time');
ylabel('Motor current (A)');
xlabel('Time (s)');
ylim([-0.5 0.5]);
xlim([0 t(end)]);

subplot(2,1,2)
plot(t,output);
title('Spring force versus time');
ylabel('Spring force (N)');
xlabel('Time (s)');
xlim([0 t(end)]);
saveas(f1,'input_output_data.png');

data = iddata(output,input,Ts);
% Number of poles
np = 2;
% Number of zeros
nz = 1;
% Estimates transfer function

SEA = tfest(data,np,nz)
% Get coefficients for estimated transfer function
wbar = 145;
beta = 100;
g1 = glead(wbar,beta);
g2 = integralboost(wbar, 1);
g3 = integralboost(1.7,1);
SEA_2 = SEA*g1*g2/g3


num = SEA.Numerator;
den = SEA.Denominator;
mk = k / den(3);
b_eff = mk * den(2);
beta = (num * mk) / k;
save('SEA.mat', 'SEA','b_eff', 'beta', 'k', 'mk','N','Fs','output','input');

% Define frequency vector
f = (0:N-1)*(Fs/N);
w = 2*pi*f;

% Obtain bode plot of model
[mag,phase,wout] = bode(SEA,w);
[mag2,phase2,wout2] = bode(SEA_2,w);
mag = reshape(mag,[N,1]);
mag2 = reshape(mag2,[N,1]);
phase = reshape(phase,[N,1]);
phase2 = reshape(phase2,[N,1]);

% Obtain frequency response of data
outputFFT = fft(output);
inputFFT = fft(input);
h_data = outputFFT ./ inputFFT;
mag_data = abs(h_data);
phase_data = angle(h_data) * (180/pi);

%% Plotting
f2 = figure;
subplot(2,1,1)
semilogx(f, mag2db(mag_data));
title('System identification of SEA');
hold on;
semilogx(f,mag2db(mag));
semilogx(f,mag2db(mag2));
ylabel('Magnitude (dB)');
xlabel('Frequency (Hz)');
text_str = {['m_k = ', num2str(mk)],['b_{eff} = ', num2str(b_eff)],...
    ['\beta = ', num2str(beta)], ['k = ', num2str(k)]};
text(0.05, 0, text_str);
xlim([0 1000]);
legend('Freq','SEA1','SEA2','Location','best')
subplot(2,1,2)
semilogx(f, phase_data);
hold on;
semilogx(f,phase);
semilogx(f,phase2);
ylabel('Phase (deg)');
xlabel('Frequency (Hz)');
legend('Data','Model');
xlim([0 1000]);
saveas(f2,'system_ID.png');

%%
figure
opts = timeoptions;
opts.Grid = 'on';
impulseplot(SEA,opts)

figure 
step(SEA)
