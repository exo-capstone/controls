function [gamma,K] = cprop2cact(Gin,Cpropin)
%CPROP2CACT  SISO McFarlane-Glover Loopshaping
%
%  [GammaOpt,Cact] = CPROP2CACT(P,CPROP) computes the optimization
%  described in ME C231A/EECS C220A for improving the stability margins of
%  a proposed controller with a constraint on overall the open-loop
%  loopshape 
%
%  If the value of GammaOpt is less than (say) 4, then the controller
%  Cact acheives a loopshape P*Cact similar to P*Cprop, and the closed-loop
%  system involving P and Cact has good gain and phase margins.
%
%  If the value of GammaOpt is large, then for every controller C which
%  stabilizes P, at least one of the following deficiencies is present: 
%     - the gain of P*C is significantly smaller than the gain of P*Cprop
%       at some frequency where the gain of P*Cprop is large.
%     - the gain of P*C is significantly larger than the gain of P*Cprop
%       at some frequency where the gain of P*Cprop is small.
%     - the robustness margins (gain/phase) of the closed-loop system
%       made up of P and C are small.
%  This implies that the large-loop-gain goals of P*Cprop, the small-loop-gain
%  goals of P*Cprop, and the need to have modest closed-loop robustness
%  margins are incompatible.
%
%  See also: integralboost, rolloff, lead1, lead2, lead3, getmag
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017

G = ss(Gin);
Cprop = ss(Cpropin);
szG = size(G);
szC = size(Cprop);
if length(szG)==2 && szG(1)==1 && szG(2)==1
   if length(szC)==2 && szC(1)==1 && szC(2)==1
     [a,b,c,d] = ssdata(G*Cprop);
     n = size(a,1);
     nu = size(b,2);
     ny = size(c,1);
     iddt = eye(ny)+d*d';
     idtd = eye(nu)+d'*d;
     Acare = a-b*(idtd\d')*c;
     Bcare = b;
     Scare = zeros(n,nu);
     Rcare = idtd;
     Qcare = c'*(iddt\c);
     Ecare = eye(n);
     [X,L1,G1] = care(Acare,Bcare,Qcare,Rcare,Scare,Ecare);

     Acare = (a-b*(d'/iddt)*c)';
     Bcare = c';
     Scare = zeros(n,ny);
     Rcare = iddt;
     Qcare = b*(idtd\b');
     Ecare = eye(n);
     [Z,L2,G2] = care(Acare,Bcare,Qcare,Rcare,Scare,Ecare);
     
     F = -idtd\(d'*c+b'*X);
     H = -(b*d'+Z*c')/iddt;
     sig = eig(Z*X);
     BackOffFactor = 1.035; 
     gamma = BackOffFactor*sqrt(1+max(real(sig)));
     W2 = eye(n)-gamma^(-2)*(eye(n)+Z*X);
     sysk = ss(a+b*F-W2\(Z*c'*(c+d*F)),W2\(Z*c'),-b'*X,-d');
     K = -Cprop*sysk;
   else
     error('CPROP must be SISO');
   end
else
  error('P must be SISO');
end
