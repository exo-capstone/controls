function dM = discMargin(L)
% DM = DISCMARGIN(L) computes gain and phase disc-margins for negative
% feedback around a scalar loopgain L.  The fields are: gainDM, phaseDM and
% freqDM

% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017

szL = [size(L) 1 1];
arrayszL = szL(3:end);
cszL = cell(arrayszL);
dM = struct('gainDM',cszL,...
   'phaseDM',cszL,...
   'freqDM',cszL);
relTol = 1e-4;
for i=1:numel(cszL)
   dM(i) = LOCALdiscMargin(L(:,:,i),relTol);
end

function dM = LOCALdiscMargin(Lsys,relTol)
% systemnames = 'Lsys'; inputvar = '[d]'; outputvar = '[d-2*Lsys]';
% input_to_Lsys = '[d-Lsys]'; H = sysic;
H = lft([1 -2;1 -1],Lsys);
[IdeltaDisc,FPeak] = norm(pade(H,4),inf,relTol);
deltaDisc = 1/IdeltaDisc;
betaDisc = (1+(deltaDisc))/(1-(deltaDisc));
dM.gainDM = [1/betaDisc, betaDisc];
dM.phaseDM = (180/pi)*atan((betaDisc^2-1)/2/betaDisc);
if isinf(betaDisc)
   dM.phaseDM = 90;
end
dM.freqDM = FPeak;
