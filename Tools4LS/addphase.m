function [G,gaindegrade] = addphase(wbar,phi,N)
% ADDPHASE  stable linear stage to add positive phase at specified frequency
% Minimizes gain increase (at high frequency) and gain reduction (at low
% frequency) necessary to achieve a phase of PHI at frequency WBAR.  The
% gain at WBAR is exactly 1.  Uses Butterworth pattern for both zeros and
% poles.  The geometric mean of the magnitude of the poles and zeros is at
% WBAR.  The number of poles equals the number of zeros, and is equal to N.
% The magnitude of G at low frequency (w=0) is 1/GAINDEGRADE, and the
% magnitude of G at high frequency is GAINDEGRADE.
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
nin = nargin;
if nin<2
   error('Need two arguments');
elseif nin==2
   N = 1;
end
if phi<=0
   error('Desired phase must be positive (in degrees).')
elseif phi>=90*N
   error('Phase requirement is not possible.');
end

betaLow = 1;
betaHigh = 1;
G = (1/betaHigh^N)*tf(bwpoly(wbar/betaHigh,N),bwpoly(wbar*betaHigh,N));
wLow = wbar/betaHigh/(5^N);
wHigh = wbar;
wgrid = logspace(log10(wLow),log10(wHigh),1000);
Gg = freqresp(G,wgrid);
A = unwrap(angle(Gg(:)));
A = A(end)*180/pi;
while A<=phi
   betaHigh = 2*betaHigh;
   G = (1/betaHigh^N)*tf(bwpoly(wbar/betaHigh,N),bwpoly(wbar*betaHigh,N));
   wLow = wbar/betaHigh/(5^N);
   wHigh = wbar;
   wgrid = logspace(log10(wLow),log10(wHigh),1000);
   Gg = freqresp(G,wgrid);
   A = unwrap(angle(Gg(:)));
   A = A(end)*180/pi;
end
while betaHigh/betaLow>1.001
   beta = sqrt(betaHigh*betaLow);
   G = (1/beta^N)*tf(bwpoly(wbar/beta,N),bwpoly(wbar*beta,N));
   wLow = wbar/beta/(5^N);
   wHigh = wbar;
   wgrid = logspace(log10(wLow),log10(wHigh),1000);
   Gg = freqresp(G,wgrid);
   A = unwrap(angle(Gg(:)));
   A = A(end)*180/pi;
   if A<=phi
      betaLow = beta;
   else
      betaHigh = beta;
   end
end
% Next line is not needed - this recreates the most current G, at exactly
% the same values.  The code (almost) guarantees that G is created at least
% once.   Leave it for now (AKP, 11/20/2013)
G = (1/beta^N)*tf(bwpoly(wbar/beta,N),bwpoly(wbar*beta,N));
gaindegrade = beta^N;