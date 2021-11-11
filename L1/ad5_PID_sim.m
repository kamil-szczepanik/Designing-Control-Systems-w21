close;
clear;
load("model.mat");
lambda = 0.001;
N = 300;
Nu = 300;
MV_MIN = 0;
MV_MAX = 100;
dMV_MIN = -10;
dMV_MAX = +10;
Kk = 38;
Tk = 154/3;
K_pid = 0.6 * Kk;
Ti_pid = 0.5*Tk;
Td_pid = Tk/8;
T = 1;
controller =  PID(K_pid, Ti_pid, Td_pid, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);

obj = double_inertial(K,Td,T1,T2,20.9700);
y_zad = ones(600,1);
y_zad(:,:) = 45;
[~, u,y] = systemSim(controller, obj, y_zad, 1, 600);

err = norm(y_zad-y)
figure(2)
stairs(u);
figure(1)
hold on
yline(45);
stairs(y);
hold off

save("PID_SIM", "K_pid", "Ti_pid", "Td_pid");