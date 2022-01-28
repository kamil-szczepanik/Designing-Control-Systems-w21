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

K_y_u = squeeze(S(end,:,:)); % Macierz wzmocnień statycznych
A = lsqminnorm(K_y_u,eye(3));  % Ogólnie ta funkcja jest świetna.  
% Tutaj na przykład dlatego, że zwróci macierz rozwiązań o minimalnej 
% normie, co jest dokładnie tym, czego porządamy. No cudo po prostu
% Kk = 21.625;
% Tk = 72;
pid_y1 =  PID(4, 6, 0.2, 0.5, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
pid_y2 =  PID(5, 2.5, 0.25, 0.5, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
pid_y3 =  PID(2, 1.75, 0.25, 0.5, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
controller = @(e) (A * [ pid_y1(e(1));pid_y2(e(2));pid_y3(e(3))])';
obj = Obj_15_p4();
[~, u,y] = systemSim4_3(controller, obj, y_zad,0.5, SIM_LENGTH+0.5);

figure()
fig = stairs(u(:,1));
writematrix([fig.XData; fig.YData]', 'txts/ad4_pid_u1.txt', "Delimiter","tab");
figure()
fig = stairs(u(:,2));
writematrix([fig.XData; fig.YData]', 'txts/ad4_pid_u2.txt', "Delimiter","tab");
figure()
fig = stairs(u(:,3));
writematrix([fig.XData; fig.YData]', 'txts/ad4_pid_u3.txt', "Delimiter","tab");
figure()
fig = stairs(u(:,4));
writematrix([fig.XData; fig.YData]', 'txts/ad4_pid_u4.txt', "Delimiter","tab");

figure()
fig = stairs(y(:,1));
writematrix([fig.XData; fig.YData]', 'txts/ad4_pid_y1.txt', "Delimiter","tab");
figure()
fig = stairs(y(:,2));
writematrix([fig.XData; fig.YData]', 'txts/ad4_pid_y2.txt', "Delimiter","tab");
figure()
fig = stairs(y(:,3));
writematrix([fig.XData; fig.YData]', 'txts/ad4_pid_y3.txt', "Delimiter","tab");
err  = norm(y-y_zad)^2
u_norm = norm(u)^2
du_norm = norm(u(1:end-1)-u(2:end))^2