close;
clear;
load("model.mat");
lambda = 0.01;
N = 25;
Nu = 1;
MV_MIN = 0;
MV_MAX = 100;
dMV_MIN = -10;
dMV_MAX = +10;

controller = DMC(Sm(1:300), lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);

obj = double_inertial(K,Td,T1,T2,20.9700);
y_zad = ones(600,1);
y_zad(1:end,:) = 45;
% y_zad(300:600,:) = 35;
[~, u,y] = systemSim(controller, obj, y_zad, 1, 600);

err = norm(y_zad-y)
figure(2)
stairs(u);
figure(1)
hold on
yline(80);
stairs(y);
hold off
