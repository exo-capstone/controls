clear all; close all; clc;
load('right_knee_open_loop_exp_chirp.mat');
input = right_knee_open_loop_exp_chirp.input;
output = -1*(right_knee_open_loop_exp_chirp.output - 4.7);

% Spring constant = 549360 N/m
% Encoder angle to spring deflection= 0.000027707 m/degrees
output = output * 0.000027707 * 549360; % Force in N

% % Centers output signal to zero
% output = output - output(1);

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

% Number of poles
np = 2;
% Number of zeros
nz = 0;
% Estimates transfer function
data = iddata(output,input,Ts);
sys = tfest(data,np,nz)
% Get coefficients for estimated transfer function
[num,den] = tfdata(sys);
% Percentage of fit of model with data
% fit = sys.Report.Fit.FitPercent;

% % Brute force search for optimal number of zeros and poles
% n = 10;
% np_test = 0;
% np = 0;
% nz = 0;
% fit = 0;
% for np_test = 1:n
%     for nz_test = 0:np_test-1
%         [np_test, nz_test]
%         sys_test = tfest(data,np_test,nz_test);
%         fit_test = sys_test.Report.Fit.FitPercent;
%         if fit_test > fit
%             np = np_test;
%             nz = nz_test;
%             sys = sys_test;
%         end
%     end
% end

% Define frequency vector
f = (0:N-1)*(Fs/N);
w = 2*pi*f;

% Obtain bode plot of model
[mag,phase,wout] = bode(sys,w);
mag = reshape(mag,[N,1]);
phase = reshape(phase,[N,1]);

% Obtain frequency response of data
outputFFT = fft(output);
inputFFT = fft(input);
h_data = outputFFT ./ inputFFT;
mag_data = abs(h_data);
phase_data = angle(h_data) * (180/pi);



f2 = figure;
subplot(2,1,1)
semilogx(f, mag2db(mag_data));
title('System identification of SEA');
hold on;
semilogx(f,mag2db(mag));
ylabel('Magnitude (dB)');
xlabel('Frequency (Hz)');
legend('Data','Model');
xlim([0 f(end)]);

subplot(2,1,2)
semilogx(f, phase_data);
hold on;
semilogx(f,phase);
ylabel('Phase (deg)');
xlabel('Frequency (Hz)');
legend('Data','Model');
xlim([0 f(end)]);
saveas(f2,'system_ID.png');

clear f1 f2
save('systemid.mat');
