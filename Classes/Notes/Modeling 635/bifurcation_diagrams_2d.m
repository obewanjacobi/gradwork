%% Initialize the environment
    close all;
    clear all;
    clc;
    %% Model parameters
    r = 0.806; 
    a = 15; 
    b = 16;
    c = 17;
    e = 0.333;
    d = 0.3;
    h = 0.01;
    K = 200;
    %% Time parameters
    dt = 0.01;
    N = 10000;
    %% Set-up figure and axes
    figure;
    ax(1) = subplot(2,1,1);
    hold on
    xlabel ('m');
    ylabel ('x');
    ax(2) = subplot(2,1,2);
    hold on
    xlabel ('m');
    ylabel ('y');
    %% Main loop
    for m=6:1:22
        x = zeros(N,1);
        y = zeros(N,1);
        t = zeros(N,1);
        x(1) = 0.7;
        y(1) = 0.11;
        t(1) = 0;
        for i=1:N
            t(i+1) = t(i) + dt;
            x(i+1) = x(i) + dt*(  r*x(i)*(1-x(i)/K)-m*x(i)*y(i)/(a*x (i)+b*y(i)+c)  );
            y(i+1) = y(i) + dt*(  e*m*x(i)*y(i)/(a*x(i)+b*y(i)+c)-d*y(i)-h*y(i)^2  );
        end
        plot(ax(1),m,x,'color','blue','marker','.');
        plot(ax(2),m,y,'color','blue','marker','.');
    end