syms x(t);

%%Input the 1st order DE here
ode = diff(x,t) == -x^3;

%%Input initial condition here
x_0 = sym('x_0')
cond = x(0) == x_0;

xSol(t) = dsolve(ode,cond);
xSol = simplify(xSol)