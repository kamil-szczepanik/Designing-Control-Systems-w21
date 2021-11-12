close;
clear;
load("data/model.mat");
load("data/DMC.mat");
controller = DMC(Sm(1:300), lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = double_inertial(K,Td,T1,T2,20.9700);

y_zad = ones(600,1) * 45;
y_zad(1:end,:) = 45;
[~, u,y] = systemSim(controller, obj, y_zad, 1, 600);
disp(norm(y_zad-y));

figure(2)
stairs(u);
figure(1)
hold on
yline(80);
stairs(y);
hold off
