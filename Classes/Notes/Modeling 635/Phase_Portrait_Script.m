f = @(t,x) [-x(2); x(1)];%insert parameters here
x1 = linspace(-5,5,25);
x2 = linspace(-5,5,25);
[x,y] = meshgrid(x1,x2);
u = zeros(size(x));
v = zeros(size(x));

t=0; % we want the derivatives at each point at t=0, i.e. the starting time
for i = 1:numel(x)
    Xprime = f(t,[x(i); y(i)]);
    u(i) = Xprime(1);
    v(i) = Xprime(2);
end

quiver(x,y,u,v,'r'); figure(gcf)
xlabel('x_1')
ylabel('x_2')
axis tight equal;

hold on
for y20 = [-5 -4 -3 -2 -1 0 1 2 3 4 5]
    [ts,ys] = ode45(f,[0,50],[0;y20]);
    plot(ys(:,1),ys(:,2))
    plot(ys(1,1),ys(1,2),'bo') % starting point
    plot(ys(end,1),ys(end,2),'ks') % ending point
end
hold off