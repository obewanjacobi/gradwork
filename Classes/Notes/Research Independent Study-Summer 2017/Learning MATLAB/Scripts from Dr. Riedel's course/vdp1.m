function dydt=vdp1(t,y,m)
dydt(1)=y(2);
dydt(2)=m*(1-y(1)).^2.*y(2)-y(1);
end;