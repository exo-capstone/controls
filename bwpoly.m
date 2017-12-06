function A = bwpoly(w,n,rhpflag,lcEq1Flag)
% P = BWPOLY(W,N) creates N'th order polynomial P (as 1-by(n+1) row vector)
% with roots in a Butterworth pattern, in the left-half plane, at magnitude
% equal to W.  The polynomial is normalized with P(END) = 1.
%
% P = BWPOLY(W,N,TRUE) causes all roots to be in the right-half plane.
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
nin = nargin;
if nin<2
   error('usage: P = BWPOLY(W,N)');
elseif nin==2
   rhpflag = false;
   lcEq1Flag = false;
elseif nin==3
   lcEq1Flag = false;
end

dsign = 1;
if rhpflag
   dsign = -1;
end
%
nd2 = n/2;
if floor(nd2)==ceil(nd2)
   thetavec = pi/2/n + (0:nd2-1)*pi/n;
   C = 1;
else
   thetavec = pi/2/n + (0:(n-1)/2-1)*pi/n;
   C = [dsign*1 1];
end
for i=1:length(thetavec)
   xi = sin(thetavec(i));
   C = conv(C,[1 dsign*2*xi 1]);
end

if ~lcEq1Flag
   A = C(1);
   for i=2:n+1
      A = [(1/w)*A C(i)];
   end
   % [C(1)/w^n C(2)/w^(n-1)       C(n)/w C(n+1)]
else
   A = C(n+1);
   for i=n:-1:1
      A = [C(i) w*A];
   end
   % [C(1) C(2)*w       C(n)*w^(n-1} C(n+1)*w^n]
end

