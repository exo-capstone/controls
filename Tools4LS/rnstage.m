function N = rnstage(wR,r,xiZ)
% RNSTAGE   Creates 2nd-order, Resonant/Notch Stage
%
% N = rnstage(wR,r,xiZ) creates a 2nd-order resonant/notch stage, with the
% following properties:
%   * 2 imaginary-axis poles at wR
%   * Magnitude of zeros = r*wR
%   * damping of zeros = xiZ
%   * gain at w=0 is equal to 1

%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
Den = [1 0 wR^2];
Num = [1/r^2 2*xiZ*wR/r wR^2];
N = tf(Num,Den);