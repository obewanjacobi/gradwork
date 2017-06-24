function dydt=myode(t,y,ft,f,gt,g)
f=interp1(ft,f,t);
g=interp1(gt,g,t);
dydt=-f.*y+y;

end