close;
clear;
load("data/model.mat");
load("data/PID_SIM.mat");
controller =  PID(K_pid, Ti_pid, Td_pid, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = double_inertial(K,Td,T1,T2,20.9700);

y_zad = ones(600,1) * 45;
[~, u,y] = systemSim(controller, obj, y_zad, 1, 600);
disp(norm(y_zad-y));

figure(2)
stairs(u);
figure(1)
hold on
yline(45);
stairs(y);
hold off
