close all;
clear;
controller =  PID(5, inf, 0, 1, -1, 1, -2, 2);
obj = double_inertial(1,0,5,1,0, 100);
y_zad = ones(600,1);
% @(x)1
[~, u,y] = systemSim(controller, obj, y_zad, 1, 600);
disp(norm(y_zad-y));

figure(2)
stairs(u);
figure(1)
hold on
yline(1);
stairs(y);
hold off
