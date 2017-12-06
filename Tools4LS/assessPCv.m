function assessPCv(varargin)
% assessPCv   visual display of various properties of closed-loop system
% consisting of SISO plant P and feedback controller C.
%    assessPCv(P,C), or assessPCv(P1,C1,P2,C2), or
%    assessPCv(P,C,Tsim,wRange) or assessPCv(P1,C1,P2,C2,Tsim,wRange) gives
%    a visual (2-by-4 array of subplots) depiction of the properties of the
%    negative-feedback loop consisting of P and C.
%
% Attribution: ME C231A, EECS C220B, UC Berkeley, 2017

nin = nargin;
WR = [];
TF = [];
if (isa(varargin{end},'double') || isa(varargin{end},'cell') || isempty(varargin{end})) && ...
      (isa(varargin{end-1},'double') || isa(varargin{end-1},'cell') || isempty(varargin{end-1}))
   a1 = varargin{end-1};
   a2 = varargin{end};
   [TF,WR] = LOCALtw(a1,a2);
   nin = nin - 2;
end
nSys = nin/2;
if floor(nSys)==ceil(nSys)
   P = ss(zeros(1,1,nSys));
   C = ss(zeros(1,1,nSys));
   for i=1:nSys
      P(:,:,i) = varargin{2*(i-1)+1};
      C(:,:,i) = varargin{2*i};
   end
   L = P*C;
   % [TF,WR] = LOCALtw(a1,a2);
   S = feedback(1,L);
   T = 1-S;
   PS = feedback(P,C);
   CS = feedback(C,P);
   Sc = cell(nSys,1); Tc = cell(nSys,1); PSc = cell(nSys,1);
   CSc = cell(nSys,1); Lc = cell(nSys,1);
   for i=1:nSys
      Sc{i} = S(:,:,i);
      Tc{i} = T(:,:,i);
      PSc{i} = PS(:,:,i);
      CSc{i} = CS(:,:,i);
      Lc{i} = L(:,:,i);
   end
      
   subplot(2,4,[1 5])
   if nSys==1
      margin(Lc{:})
   else
      bode(Lc{:});
   end
   subplot(2,4,2);
   bodemag(Sc{:},WR)
   title('|S|')
   ylim([-50 10])
   subplot(2,4,6);
   bodemag(Tc{:},WR)
   title('|T|')
   ylim([-50 10])
   subplot(2,4,7)
   bodemag(CSc{:},WR)
   title('Mag: C/(1+PC)')
   subplot(2,4,3)
   impulse(PSc{:},TF)
   title('Imp: P/(1+CP)')
   subplot(2,4,4);
   step(PSc{:},TF)
   title('Step: P/(1+CP)')
   subplot(2,4,8);
   step(Tc{:},TF)
   title('Unit-Step: T')
else
   error('Input argument should be pairs of P and C')
end

function [TF,WR] = LOCALtw(a1,a2)
if isempty(a1) && isempty(a2)
   TF = []; WR = [];
elseif isempty(a2)
   if isa(a1,'double')
      TF = a1; WR = [];
   elseif isa(a1,'cell')
      WR = a1; TF = [];
   end
elseif isempty(a1)
   if isa(a2,'double')
      TF = a2; WR = [];
   elseif isa(a2,'cell')
      WR = a2; TF = [];
   end
else
   if isa(a2,'double')
      TF = a2;
   elseif isa(a2,'cell')
      WR = a2;
   end
   if isa(a1,'double')
      TF = a1;
   elseif isa(a1,'cell')
      WR = a1;
   end
end