function G = notch(wbar,xi)
% NOTCH creates notch filter (continuous-time), with no poles.
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
%
G = tf([1/wbar^2 2*xi/wbar 1],[1]);