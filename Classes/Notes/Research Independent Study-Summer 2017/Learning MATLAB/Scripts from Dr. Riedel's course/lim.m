function dydt=lim(t,y,ft,f,gt,g)
ft=linspace(0,5,25);
gt=linspace(0,5,25);
f=ft.^2-3;
g=3*sin(gt);
end
