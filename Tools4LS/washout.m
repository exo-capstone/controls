function F = washout(wbar,n)
% WASHOUT creates a washout filter (zero at 0), with specified order and
% cutoff frequency.
% 
% F = washout(WBAR) creates a first-order system, with magnitude equal to
% 0 at low-frequency, 1 at high-frequency, and a cut-off frequency of WBAR.
%
% F = washout(WBAR,N) creates a N'th-order system, with magnitude equal to
% 0 at low-frequency, 1 at high-frequency, and a cut-off frequency of WBAR.
% The washout is N'th order, using a Butterworth pattern for the poles.

% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
nin = nargin;
if nin<1
   error('There must be at least one argument.');
elseif nin==1
   n = 1;
end
F = tf([1/wbar^n zeros(1,n)],bwpoly(wbar,n));

