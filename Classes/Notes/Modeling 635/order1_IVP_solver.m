syms x(t);
syms x_0;
syms c_1;
syms c_2;
syms c_3;
c = [c_1;c_2;c_3];

%%Input the 1st order DE here
ode = diff(x,t) == -x+(c_1*exp(-t))^2;

%%Input initial condition here
cond = x(0) == c_3;

xSol(t) = dsolve(ode,cond);
xSol = simplify(xSol)