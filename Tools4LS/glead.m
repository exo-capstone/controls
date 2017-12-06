function F = glead(wbar,betaVec,n,Order)
% F = GLEAD(W,B) creates a 1st-order, stable lead network F, satisfying
% F(0) = 1/B, ABS(F(j*W))=1, and F(Inf)=B.  The return argument F is a
% continuous-time, TF object.   Both W and B are scalars, with W>0 and B>1.
%
% F = GLEAD(W,B,N) creates a Nth-order, stable lead network F, satisfying
% F(0) = 1/B, ABS(F(j*W))=1, and F(Inf)=B.  The poles and zeros of F are
% chosen using a Butterworth pattern.   N should be a positive integer.
%
% For both cases, if B is 1-by-2, with B(1)<1<B(2), then F satisfies
% F(0)=B(1), ABS(F(j*W))=1, and F(Inf)=B(2), allowing for unsymmetric
% (relative to W) lead action.
%
% F = GLEAD(W,B,N,NF) where N>0 is not an integer, but NF is, uses a NF'th
% order system to approximate the lead action, with slope specified by the
% non-integer N.  This is useful in creating fractional system
% approximations.
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
nin = nargin;
if nin<2
   error('There must be two arguments');
elseif nin==2
   n = 1;
end

if isscalar(betaVec)
   betaL = 1/betaVec;
   betaH = betaVec;
else
   betaL = betaVec(1);
   betaH = betaVec(2);
end

if floor(n)==ceil(n)
   N = bwpoly(wbar*betaL,n);  % always equal 1 at s=0
   D = bwpoly(wbar*betaH,n);  % always equal 1 at s=0
   F = (betaL^(n))*tf(N,D);
else
   N = 300;
   OmegaVec = logspace(log10(wbar*betaL)-2,log10(wbar*betaH)+2,N);
   idx1 = OmegaVec<wbar*betaL;
   idx2 = OmegaVec>= wbar*betaL & OmegaVec<= wbar*betaH;
   idx3 = OmegaVec>wbar*betaH;
   MagVec = zeros(N,1);
   MagVec(idx1) = (1/beta)^n;
   MagVec(idx3) = beta^n;
   MagVec(idx2) = (OmegaVec(idx2)/wbar).^n;
   Mag = frd(reshape(MagVec,[1 1 N]),OmegaVec);
   CMag = genphase(Mag);
   F = fitfrd(CMag,Order,[],1/Mag);
end
