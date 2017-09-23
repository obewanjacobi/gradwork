syms x(t);

%%Input the 1st order DE here
ode = diff(x,t) == x+1-t;

%%Input initial condition here
cond = x(0) == 1;

xSol(t) = dsolve(ode,cond);
xSol = simplify(xSol)