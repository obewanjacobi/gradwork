syms x(t) y(t) c_1 c_2 c_3;
ode1 = diff(x) == x*(c_3-x^2);
ode2 = diff(y) == 1;
odes = [ode1; ode2];
cond1 = x(0) == c_1;
cond2 = y(0) == c_2;
conds = [cond1; cond2];
[xSol(t), ySol(t)] = dsolve(odes,conds);
xSol = simplify(xSol);
ySol = simplify(ySol);
xSol(t) = xSol(t)
ySol(t) = ySol(t)