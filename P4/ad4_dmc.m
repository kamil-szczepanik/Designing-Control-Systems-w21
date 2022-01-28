close all;
clear;
load('data/model.mat');
MV_MIN = -100;
MV_MAX = 100;
dMV_MIN = -inf;
dMV_MAX = inf;
SIM_LENGTH = 500;
y_zad = zeros(SIM_LENGTH*2,3);
y_zad(200:end,:) = 16;
y_zad(400:end,1) = 9;
y_zad(600:end,2) = 20;
y_zad(700:end,3) = 12;
y_zad(800:end,:) = 3;


controller = DMC(S, 1, 1, 301, 301, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15_p4();
[~, u,y] = systemSim4_3(controller, obj, y_zad,0.5, SIM_LENGTH+0.5);

figure()
fig = stairs(u(:,1));
writematrix([fig.XData; fig.YData]', 'txts/ad4_dmc_u1.txt', "Delimiter","tab");
figure()
fig = stairs(u(:,2));
writematrix([fig.XData; fig.YData]', 'txts/ad4_dmc_u2.txt', "Delimiter","tab");
figure()
fig = stairs(u(:,3));
writematrix([fig.XData; fig.YData]', 'txts/ad4_dmc_u3.txt', "Delimiter","tab");
figure()
fig = stairs(u(:,4));
writematrix([fig.XData; fig.YData]', 'txts/ad4_dmc_u4.txt', "Delimiter","tab");

figure()
fig = stairs(y(:,1));
writematrix([fig.XData; fig.YData]', 'txts/ad4_dmc_y1.txt', "Delimiter","tab");
figure()
fig = stairs(y(:,2));
writematrix([fig.XData; fig.YData]', 'txts/ad4_dmc_y2.txt', "Delimiter","tab");
figure()
fig = stairs(y(:,3));
writematrix([fig.XData; fig.YData]', 'txts/ad4_dmc_y3.txt', "Delimiter","tab");
err  = norm(y-y_zad)^2
u_norm = norm(u)^2
du_norm = norm(u(1:end-1)-u(2:end))^2
