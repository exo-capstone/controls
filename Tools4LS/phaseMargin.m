function [PM,DPM] = phaseMargin(L)
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
m = assessL(L);
PM = min(abs(m.PhaseMargin));
if isempty(PM)
   PM = 180;
end
DPM = m.phaseDM;