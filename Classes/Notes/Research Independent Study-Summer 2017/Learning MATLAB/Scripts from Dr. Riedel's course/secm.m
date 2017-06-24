function y=secm(g,a,b,err)
i=1;
c=(a*g(b)-b*g(a))/(g(b)-g(a));
disp('Xn-1 g(Xn-1) Xn g(Xn) Xn+1 g(Xn+1)');
disp([a g(a) b g(b) c g(c)]);
while abs(g(c)) > err
    a = b;
    b = c;
    c = (a*g(b)-b*g(a))/(g(b)-g(a));
    disp([a g(a) b g(b) c g(c)]);
    i=i+1;
    if(i==100)
        break;
    end
end
disp(['root is x =' ,(c)]);
y=c;