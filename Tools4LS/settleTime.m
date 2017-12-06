function Tsettle = settleTime(T,Y,Ybar,absTol)
% Tsettle = settleTime(T,Y,Ybar,absTol)
%        Defn: LastTime that |y(t)-yBar|>=absTol

% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
idx = find(abs(Y-Ybar)>=absTol);
if isempty(idx)
   Tsettle = 0;
else
   Tsettle = T(idx(end));
end