function [sys] = cnum2sys(Value,PFreq)
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017

if isreal(Value)
   sys = ss([],[],[],Value);
else
   disk = Value/abs(Value);
   sw = 1;
   if imag(disk) < 0
      sw = -1;  disk = -disk;
   end
   pscal = sqrt(abs(Value));
   beta = (imag(disk)*PFreq)/(1+real(disk));
   bc = sqrt(2*beta);
   sys = ss(-beta,-pscal*bc,sw*pscal*bc,pscal*pscal*sw);
end
