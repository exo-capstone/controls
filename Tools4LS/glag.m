function F = glag(wbar,beta,n,Order)
% function F = glag(wbar,beta,n,Order)
% Generalized LAG network, using butterworth patterns for
% poles and zeros.  See GLEAD
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017

nin = nargin;
if nin<2
   error('There must be two arguments');
elseif nin==2
   n = 1;
end

if floor(n)==ceil(n)
   N = bwpoly(wbar*beta,n);
   D = bwpoly(wbar/beta,n);
   F = (beta^(n))*tf(N,D);
else
   N = 300;
   OmegaVec = logspace(log10(wbar/beta)-2,log10(wbar*beta)+2,N);
   idx1 = find(OmegaVec<wbar/beta);
   idx2 = find(OmegaVec>= wbar/beta & OmegaVec<= wbar*beta);
   idx3 = find(OmegaVec>wbar*beta);
   MagVec = zeros(N,1);
   MagVec(idx1) = (beta)^n;
   MagVec(idx3) = (1/beta)^n;
   MagVec(idx2) = (wbar./OmegaVec(idx2)).^n;
   Mag = frd(reshape(MagVec,[1 1 N]),OmegaVec);
   CMag = genphase(Mag);
   F = fitfrd(CMag,Order,[],1/Mag);
end
