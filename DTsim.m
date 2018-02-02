function SYS = DTsim(P,PD,PinvQ,Q,F)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                                               d
%                                               |
%         s4        s5                          v
% fd-->--+o--fr----+o--e-[ F ]--ef--[ PD ]--i---o--id---------=-[ P ]--->fk
%        -|      |  |-                 s2                           s3|   
%         |      |  --------------------------------------------------o<--n
%         |      |       frq  s1 fk_fdbk_pq               |fk_fdbk
%         |      ---[ Q ]-----o----------[ P^-1*Q ]--------
%         |                  -|+
%         ---------------------        
%             dob
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define Plant input/output
P.u = 'id';
P.y = 'fk';
% Define Controller input/output
PD.u = 'ef';
PD.y = 'i';
% Define Butterworth Filter input/output
F.u = 'e';
F.y = 'ef';

Q.u = 'fr';
Q.y = 'frq';

PinvQ.u = 'fk_fdbk';
PinvQ.y = 'fk_fdbk_pq';

inp_sys = {'fd'; 'n'; 'd'};
out_sys = {'fk'};

s1 = sumblk('dob = fk_fdbk_pq - frq');
s2 = sumblk('id = i + d');
s3 = sumblk('fk_fdbk = fk + n');
s4 = sumblk('fr = fd - dob');
s5 = sumblk('e = fr - fk_fdbk');

SYS = tf(connect(P,PD,F,Q,PinvQ,s1,s2,s3,s4,s5,inp_sys,out_sys));

end