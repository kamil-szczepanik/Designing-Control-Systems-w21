close all;
clear;
load('data/model.mat');
MV_MIN = -100;
MV_MAX = 100;
dMV_MIN = -inf;
dMV_MAX = inf;
SIM_LENGTH = 400;
y_zad = zeros(SIM_LENGTH*2,1);
y_zad(200:400) = 10;
y_zad(400:600) = 4;
y_zad(600:800) = -0.1;
controller = DMC(S, 1, 1, 300, 300, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15_p4();
[~, u,y] = systemSim4_3(controller, obj, y_zad,0.5, SIM_LENGTH+0.5);

figure(1)
fig = stairs(y(:,1));
% writematrix([fig.XData; fig.YData]', 'txts/ad1_y1.txt', "Delimiter","tab");
figure(2)
fig = stairs(y(:,2));
% writematrix([fig.XData; fig.YData]', 'txts/ad1_y2.txt', "Delimiter","tab");
figure(3)
fig = stairs(y(:,3));
% writematrix([fig.XData; fig.YData]', 'txts/ad1_y3.txt', "Delimiter","tab");