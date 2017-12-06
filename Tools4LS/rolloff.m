function F = rolloff(wbar,n)
% F = rolloff(WBAR)
% creates a first-order system, with magnitude equal to
% 1 at low frequency, and a cut-off frequency of WBAR.
%
% F = rolloff(WBAR,N)
% creates a N'th-order system, with magnitude equal to
% 1 at low frequency, and a cut-off frequency of WBAR.
% The rolloff is N'th order, using a Butterworth pattern
% for the poles.

% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
nin = nargin;
if nin<1
   error('There must be at least one argument.');
elseif nin==1
   n = 1;
end
F = tf(1,bwpoly(wbar,n));

