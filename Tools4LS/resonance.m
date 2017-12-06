function G = resonance(wbar,xi)
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
%
G = tf(1,[1/wbar^2 2*xi/wbar 1]);