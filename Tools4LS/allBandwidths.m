function BW = allBandwidths(L, SF)
% BW = ALLBANDWIDTHS(L) computes closed-loop sensitivity and complementary
% sensitivity bandwidths for negative feedback around a scalar loopgain L.
% The bandwidth ratio, wTb/wSb is computed, as are the peak (over
% frequency) of S and T.   BW is a struct array, with dimension equal to
% the array dimension of L.  The fields are: bwS, bwT, bwRatio, PeakS,
% PeakT.

% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017

nin = nargin;
szL = [size(L) 1 1];
arrayszL = szL(3:end);
S = feedback(1,L);
clpStable = zeros(arrayszL);
for i=1:numel(clpStable)
   if nin==2
      clpStable(i) = SF(i);
   elseif hasdelay(S(:,:,i))
      clpStable(i) = NaN;
   else
      clpStable(i) = isstable(S(:,:,i));
   end
end
T = 1 - S;
relTol = 0.01;
bwS = LOCALgetSensitivityBW(S,relTol);
bwT = LOCALgetCompSensitivityBW(T,relTol);
BW = struct('bwS',num2cell(bwS),...
   'bwT',num2cell(bwT),...
   'bwRatio',num2cell(bwT./bwS),...
   'PeakS',num2cell(norm(pade(S,4),inf,relTol)),...
   'PeakT',num2cell(norm(pade(T,4),inf,relTol)));

function wSb = LOCALgetSensitivityBW(S,relTol)
% Two simple "edge" cases, with no crossovers of 1/sqrt(2), for different
% reasons.
% L = tf([10 1],[1.0 0.2]); S = feedback(1,L);  % never goes above 0.7
% L = tf([-0.5 -0.7],[1 1]); S = feedback(1,L); % never goes below 1
szS = [size(S) 1 1];
arrayszS = szS(3:end);
wSb = zeros(arrayszS);
for i=1:numel(wSb)
   wSbCandidates = getGainCrossover(S(:,:,i),1/sqrt(2));
   if isempty(wSbCandidates)
      if norm(S(:,:,i),inf)>(1/sqrt(2))
         wSb(i) = 0;
      else
         wSb(i) = inf;
      end
   else
      if hasdelay(S(:,:,i))
         tmp = log10(wSbCandidates(1));
         wVec = [0 logspace(tmp-4,tmp,1000)];
         GainValue = getPeakGain(frd(S(:,:,i),wVec),relTol,[0 wSbCandidates(1)]);
      else
         GainValue = getPeakGain(S(:,:,i),relTol,[0 wSbCandidates(1)]);
      end
      if GainValue <= (1/sqrt(2))*(1+relTol)
         wSb(i) = wSbCandidates(1);
      else
         wSb(i) = 0;
      end
   end
end

function wTb = LOCALgetCompSensitivityBW(T,relTol)
szT = [size(T) 1 1];
arrayszT = szT(3:end);
wTb = zeros(arrayszT);
for i=1:numel(wTb)
   wTbCandidates = getGainCrossover(T(:,:,i),1/sqrt(2));
   if isempty(wTbCandidates)
      if norm(T(:,:,i),inf)>(1/sqrt(2))
         wTb(i) = inf;
      else
         wTb(i) = 0;
      end
   else
      if hasdelay(T(:,:,i))
         tmp = log10(wTbCandidates(end));
         wVec = [logspace(tmp,tmp+5,2000)];
         GainValue = getPeakGain(frd(T(:,:,i),wVec),relTol,[wTbCandidates(end) inf]);
      else
         GainValue = getPeakGain(T(:,:,i),relTol,[wTbCandidates(end) inf]);
      end
      if GainValue <= (1/sqrt(2))*(1+relTol)
         wTb(i) = wTbCandidates(end);
      else
         wTb(i) = inf;
      end
   end
end