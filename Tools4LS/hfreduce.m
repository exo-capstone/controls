function F = hfreduce(wbar,beta,n)
% function F = hfreduce(wbar,beta,n)
% 1 at low freq, turns down at wbar, flattens out at wbar*beta to mag
% of 1/beta^n
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017

nin = nargin;
if nin<2
   error('There must be one argument.');
elseif nin==2
   n = 1;
end
Num = bwpoly(wbar*beta,n);
Den = bwpoly(wbar,n);
F = tf(Num,Den);

