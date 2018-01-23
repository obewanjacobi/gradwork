syms x(t)
Dx = diff(x,t);
D2x = diff(x,t,2);

%%Input 3rd order DE here
ode = diff(x,t,3) == x;

%%Input initial conditions
cond1 = x(0) == 1;       
cond2 = Dx(0) == -1;
cond3 = D2x(0) == pi;

conds = [cond1 cond2 cond3];
xSol(t) = dsolve(ode,conds);
xSol = simplify(xSol)