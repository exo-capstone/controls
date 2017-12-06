function F = bandpass(wbar,beta,n)
% bandpass    Bandpass filter, with specified center frequency and width
%
% F = bandpass(WBAR,BETA) creates a 2nd-order bandpass system, with
% frequency-response equal to 1 (exactly) at WBAR, and corner frequencies
% at [WBAR/beta  beta*WBAR].  The gain at w=0 and at w=inf is 0.
%
% F = bandpass(WBAR,BETA,N)
% creates a (2N)'th-order bandpass system, with frequency-response equal to
% 1 (exactly) at WBAR, and corner frequencies at [WBAR/beta  beta*WBAR].
% The gain at w=0 and w=inf is 0.  The poles and zeros are arranged using
% a Butterworth pattern.
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
nin = nargin;
if nin<2
   error('usage: F = bandpass(wBar,beta)');
end
if nargin==2
   n = 1;
end

F = tf([1 zeros(1,n)],bwpoly(wbar/beta,n))*tf(1,bwpoly(wbar*beta,n));
F = F/real(freqresp(F,wbar));

