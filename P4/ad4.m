close all;
clear;
global T MV_MIN MV_MAX dMV_MIN dMV_MAX SIM_LENGTH Y_ZAD
T = 0.5;
MV_MIN = -1;
MV_MAX = 1;
dMV_MIN = -inf;
dMV_MAX = inf;
SIM_LENGTH = 400;
y_zad1 = zeros(SIM_LENGTH*2,1);
y_zad1(200:400) = 1.2;
y_zad1(400:600) = 0.4;
y_zad1(600:800) = 1;

Y_ZAD = [y_zad1, y_zad1, y_zad1];

K = 1;
Ti = 5;
Td = 0;
obj = Obj_15_p4();
controller = PID(K, Ti, Td, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
[~, U, Y] = systemSim(controller, obj, Y_ZAD,0.5, SIM_LENGTH+0.5);

u1 = U(:,1);
u2 = U(:,2);
u3 = U(:,3);
u4 = U(:,4);
y1 = Y(:,1);
y2 = Y(:,2);
y3 = Y(:,3);

figure()
hold on
fig = stairs(y_zad1);
% writematrix([fig.XData; fig.YData]','txts/ad4_y_zad.txt', "Delimiter","tab");
fig = stairs(y1);
% writematrix([fig.XData; fig.YData]','txts/ad4_y.txt', "Delimiter","tab");
hold off

figure()
hold on
fig = stairs(y_zad1);
% writematrix([fig.XData; fig.YData]','txts/ad4_y_zad.txt', "Delimiter","tab");
fig = stairs(y2);
% writematrix([fig.XData; fig.YData]','txts/ad4_y.txt', "Delimiter","tab");
hold off

figure()
hold on
fig = stairs(y_zad1);
% writematrix([fig.XData; fig.YData]','txts/ad4_y_zad.txt', "Delimiter","tab");
fig = stairs(y3);
% writematrix([fig.XData; fig.YData]','txts/ad4_y.txt', "Delimiter","tab");
hold off

% figure()
% hold on
% fig = stairs(u);
% % writematrix([fig.XData; fig.YData]','txts/ad4_u.txt', "Delimiter","tab");
% hold off
% save("data/ad4_PID");
% function loss = f(params)
%     global T MV_MIN MV_MAX dMV_MIN dMV_MAX SIM_LENGTH y_zad
%     K = params(1);
%     Ti = params(2);
%     Td = params(3);
% 	obj = Obj_15Y_p3();
%     controller = PID(K, Ti, Td, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
%     [~, ~,y] = systemSim(controller, obj, y_zad,0.5, SIM_LENGTH+0.5);
%     loss = norm(y_zad-y);
% end