function F = lfboost(wbar,beta,n)
% LFBOOST  Increase gain below a specified frequency
%
% F = lfboost(wbar,beta)
%    F(0) = beta at low freq, magnitude turns down at wbar/beta, flattening
%    out at w = wbar, with F(infty) = 1.  F is a stable, minimum-phase
%    1st-order system.
%
% F = lfboost(wbar,beta,n)
%    F(0) = beta^n at low freq, magnitude turns down at wbar/beta,
%    flattening out at w = wbar to a magnitude of F(infty) = 1.  F is a
%    stable, minimum-phase n'th-order system, using a Butterworth pattern
%    for both poles and zeros.
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
nin = nargin;
if nin<2
   error('There must be one argument.');
elseif nin==2
   n = 1;
end
% Num = (beta^n)*bwpoly(wbar,n);
% Den = bwpoly(wbar/beta,n);
Num = bwpoly(wbar,n,false,true);
Den = bwpoly(wbar/beta,n,false,true);
F = tf(Num,Den);

