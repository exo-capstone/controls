function M = getmag(P,w)
% GETMAG  Returns the magnitude, as a scalar DOUBLE, of a
%         scalar LTI system object at a specified frequency
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
M = abs(freqresp(P,w));