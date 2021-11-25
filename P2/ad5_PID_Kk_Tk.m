clear;
close all;
load("PID_ad5.mat");
SIM_LENGHT = 10000;
MV_MIN = 0.9;
MV_MAX = 1.5;
dMV_MIN = -0.25;
dMV_MAX = 0.25;
y_zad = zeros(SIM_LENGHT*2,1) + 1.5;

Kk = 0.970;
controller = PID(Kk, Inf, 0, 0.5, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p1();
[~,U_pid_970,Y_pid_970] = systemSim(controller, obj, y_zad, 0.5, SIM_LENGHT+0.5);


Kk = 0.975;
controller = PID(Kk, Inf, 0, 0.5, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p1();
[~,U_pid_975,Y_pid_975] = systemSim(controller, obj, y_zad, 0.5, SIM_LENGHT+0.5);


figure()
hold on
stairs(y_zad)
stairs(Y_pid_970)
hold off
figure()
hold on
stairs(y_zad)
stairs(Y_pid_975)
hold off
figure()
hold on
stairs(y_zad(1600:2200))
stairs(Y_pid_975(1600:2200))
hold off