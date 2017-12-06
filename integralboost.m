function F = integralboost(wbar,n)
% Integrator, flattens out at w=wbar
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
nin = nargin;
if nin<1
   error('usage: F = INTEGRALBOOST(WBAR)');
elseif nin==1
   n = 1;
end
% Num = (wbar^n)*bwpoly(wbar,n);
Num = bwpoly(wbar,n,false,true);
Den = [1 zeros(1,n)];
F = tf(Num,Den);

