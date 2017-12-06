function F = hfboost(wbar,beta,n)
% HFBOOST  Increase gain beyond a specified frequency
%
% F = hfboost(wbar,beta)
%    F(0) = 1 at low freq, magnitude turns up at wbar, flattening out at
%    w = beta*wbar, with F(infty) = 1.  F is a stable, minimum-phase
%    1st-order system.
%
% F = hfboost(wbar,beta,n)
%    F(0) = 1 at low freq, magnitude turns up at wbar, flattening out at
%    w = beta*wbar to a magnitude of F(infty) = beta^n. F is a stable,
%    minimum-phase n'th-order system, using a Butterworth pattern for both
%    poles and zeros.
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
nin = nargin;
if nin<2
   error('There must be one argument.');
elseif nin==2
   n = 1;
end
Num = bwpoly(wbar,n);
Den = bwpoly(beta*wbar,n);
F = tf(Num,Den);

