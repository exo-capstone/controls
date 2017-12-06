function M = magslope(wbar,beta,slope)
% M = magslope(wbar,beta,slope)
%
% Example: Draw a magnitude with slope of -1.5 (on log/log), with magnitude
% equal to 1 at w=4, starting at 0.1*4 and ending at 10*4
%
% M = magslope(4, 10, -1.5);
% bodemag(M)
%
% M = magslope([4,6,9], 10, -1.5);
% bodemag(M)

% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
sVec = [1/beta 1 beta];

wVec = wbar*sVec;
MagValue = sVec.^slope;
M = frd(reshape(MagValue,[1 1 3]),wVec);
