function [GM,GMF,PM,PMF,DM,DMF] = scalarMargins(A)
% Extract miniumum margins, as scalars, from |allmargin| results
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017

LowerGMidx = A.GainMargin<1;
[GML,Lidx] = max(A.GainMargin(LowerGMidx));
GMLF = A.GMFrequency(Lidx);

UpperGMidx = A.GainMargin>1;
[GMU,Uidx] = min(A.GainMargin(UpperGMidx));
GMUF = A.GMFrequency(Uidx);

GM = [GML GMU];
GMF = [GMLF GMUF];

[PM,Pidx] = min(abs(A.PhaseMargin));
PMF = A.PMFrequency(Pidx);

[DM,Didx] = min(A.DelayMargin);
DMF = A.DMFrequency(Didx);
