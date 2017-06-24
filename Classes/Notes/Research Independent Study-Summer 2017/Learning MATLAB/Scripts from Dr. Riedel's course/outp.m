function [prd,sm]=outp(g,a,b)
%outp takes inputs a function g and two reals and outputs the product
%sum out the function values
prd=g(a)*g(b);
sm=g(a)+g(b);
end
