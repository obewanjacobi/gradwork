syms x(t);
x_0 = sym('x_0');
c_1 = sym('c_1');
c_2 = sym('c_2');

%%Input the 1st order DE here
ode = diff(x,t) == 2*x;

%%Input initial condition here
cond = x(0) == 0;

xSol(t) = dsolve(ode,cond);
xSol = simplify(xSol)