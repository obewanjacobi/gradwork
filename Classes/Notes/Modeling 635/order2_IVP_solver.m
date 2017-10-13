syms x(t)
Dx = diff(x);

%%Input 2nd order DE here
ode = diff(x,t,2) == sin(3*t)-2*Dx-2*x; 

%%Input initial conditions
cond1 = x(0) == 0;
cond2 = Dx(0) == 1;

conds = [cond1 cond2];
xSol(t) = dsolve(ode,conds);
xSol = simplify(xSol)