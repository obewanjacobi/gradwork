data = [1 2 3; 4 5 6; 7 8 9];

v = data(2,3);

q = data(end,3);

p = data(end-1,3);

density = data(:,2);

volumes = data(:,end-1:end);

t = density(2);

v2 = data(:,end);
v2(1) = .5;

