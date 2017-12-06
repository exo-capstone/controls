function Trise = riseTime(T,Y,Ybar,absTol)
% Trise = riseTime(T,Y,Ybar,absTol)
%        Defn: FirstTime that |y(t)-yBar|<=absTol
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017
idx = find(abs(Y-Ybar)<=absTol);
if isempty(idx)
   Trise = T(end);
else
   Trise = T(idx(1));
end
