wc = 0.2;
G = tf([-1 0 4],[1 0 1 0]);
K = 1/getmag(G,wc);
[Gam,Ca] = cprop2cact(G,K);
Gam

%%
TS = 0.5;
Gd = c2d(G,TS);
Cad = c2d(Ca,TS);
step(feedback(Gd*Cad,1),feedback(G*Ca,1),40)

%%
allmargin(Gd*Cad)
