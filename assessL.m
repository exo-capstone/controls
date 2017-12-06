function AM = assessL(L)
%assessL    Extension to ALLMARGIN
%   M = assessL(L) calls ALLMARGIN, and appends 8 fields to the result, all
%   pertaining to the unity-gain, negative feedback loop with open-loop
%   gain equal to L.  The added fields are: bwS (Sensitivity bandwidth);
%   bwT (Complementary Sensitivity bandwith); bwRatio (bwT/bwS); PeakS
%   (peak magnitude of |S|); PeakT (peak magnitude of |T|); gainDM (disc-margin
%   gain margin); phaseDM (disc-margin phase margin); freqDM (disc-margin
%   critical frequency).
%
% Example
%   L = tf([-0.2 1],conv([0.2 1],[1 0]));
%   assessL(L)
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017

AM = allmargin(L);
BW = allBandwidths(L, [AM.Stable]);
DM = discMargin(L);
for i=1:numel(AM)
    AM(i).bwS = BW(i).bwS;
    AM(i).bwT = BW(i).bwT;
    AM(i).bwRatio = BW(i).bwRatio;
    AM(i).PeakS = BW(i).PeakS;
    AM(i).PeakT = BW(i).PeakT;
    AM(i).gainDM = DM(i).gainDM;
    AM(i).phaseDM = DM(i).phaseDM;
    AM(i).freqDM = DM(i).freqDM;
end    
