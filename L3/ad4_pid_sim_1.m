close all;
clear;
load("data/ad3_y45.mat");
global T MV_MIN MV_MAX dMV_MIN dMV_MAX SIM_LENGTH y_zad  K T1 T2 Td
T = 0.5;
MV_MIN = 0;
MV_MAX = 100;
dMV_MIN = -inf;
dMV_MAX = inf;
SIM_LENGTH = 640;
y_zad = ones(SIM_LENGTH,1) * 25;
y_zad(60:end,:) = 50;
y_zad(400:end,:) = 30;

obj = double_inertial(K,Td,T1,T2,22.7317);
Kk = 28;
Tk = 45.7;
Kg = 0.6*Kk;
Ti = 0.5*Tk;
Td_pid = 0.125*Tk;
% Ti = inf;
% Td_pid = 0;
controller = PID(Kg, Ti, Td_pid, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
[~, u,y] = systemSim(controller, obj, y_zad,1, SIM_LENGTH);
figure()
hold on
fig = stairs(y_zad);
% writematrix([fig.XData; fig.YData]','txts/ad4_y_zad.txt', "Delimiter","tab");
fig = stairs(y);
% writematrix([fig.XData; fig.YData]','txts/ad4_y.txt', "Delimiter","tab");
hold off
figure()
hold on
fig = stairs(u);
% writematrix([fig.XData; fig.YData]','txts/ad4_u.txt', "Delimiter","tab");
hold off
save("data/ad4_PID_45");