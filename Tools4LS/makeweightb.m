function Tf = makeweightb(LFgain,weq1,HFgain,n)
% makeweightb  Create weighting function with monotonic (increasing or
%    decreasing) magnitude, specified low and high frequency gain, specified
%    order, and frequency at which gain equals 1.
%
%    W = makeweightb(DCgain,CROSSW,HFgain,N) creates a stable, N'th order
%    system W.  The frequency response of W satisfies G(j*0) = DCgain,
%    |W(j*CROSSW)| = 1, and W(j*infty) = HFgain.  It must be that
%    |DCgain| < 1 < |HFgain|, or |HFgain| < 1 < |DCgain|.  The poles and
%    zeros of W have a Butterworth pattern.
%
% Copyright 2011 MUSYN Inc. and The MathWorks, Inc.
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017

if nargin==3
   n = 1;
end

beta = (sqrt(HFgain/LFgain))^(1/n);
num = bwpoly(1/beta,n);  % trailing coeff = 1
den = bwpoly(beta,n);
T = LFgain*tf(num,den);

logBeta = log10(beta);
wTest = logspace(-logBeta-1,logBeta+1,15);
Tg = freqresp(T,wTest);
aTg = abs(Tg(:));

if LFgain>1
   sit = 'd';
   iStart = find(aTg>1, 1, 'last' );
   iEnd = iStart+1;
else
   sit = 'i';
   iStart = find(aTg<1, 1, 'last' );
   iEnd = iStart+1;
end
wStart = wTest(iStart);
wEnd = wTest(iEnd);

while wEnd-wStart>(abs(beta-1/beta))*0.001
   wCheck = 0.5*(wStart+wEnd);
   fCheck = abs(freqresp(T,wCheck));
   if fCheck>1
      if sit=='d'
         wStart = wCheck;
      else
         wEnd = wCheck;
      end
   else
      if sit=='d'
         wEnd = wCheck;
      else
         wStart = wCheck;
      end
   end
end
wUse = 0.5*(wStart+wEnd);
[a,b,c,d] = ssdata(T);
wScale = weq1/wUse;
Tf = ss(wScale*a,sqrt(wScale)*b,sqrt(wScale)*c,d);
      



