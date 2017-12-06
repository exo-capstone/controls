function F = allpass(wbar,n)
% F = ALLPASS(B) creates stable, first-order all-pass transfer function
% with pole magnitude (and zero magnitude) equal to B.
%
% F = ALLPASS(B,N) creates stable, N'th-order all-pass transfer function
% with pole magnitude equal to B.  Poles and zeros use a Butterworth
% pattern.
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017

nin = nargin;
if nin<1
   error('usage: F = allpass(w)');
elseif nin==1
   n = 1;
end
F = tf(bwpoly(wbar,n,true),bwpoly(wbar,n));

