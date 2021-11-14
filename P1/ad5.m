clear;
close;
load("model.mat");
%Kkrytyczne = 0.975
%T = 55
SIM_LENGHT = 500;
deltaUmax = 0.25;
lambda = 0.001;
N = 50;
Nu = 50;
MV_MIN = 0.9;
MV_MAX = 1.5;
dMV_MIN = -0.25;
dMV_MAX = 0.25;


y_zad = zeros(SIM_LENGHT*2,1);
y_zad(200:SIM_LENGHT*2) = 1.5;
y_zad(500:800) = 2.5;
y_zad(800:1000) = 2;


controller = DMC(s, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p1();
[~,U_dmc,Y_dmc] = systemSim(controller, obj, y_zad, 0.5, SIM_LENGHT+0.5);

controller = PID(0.585, 27.5, 6.6, 0.5, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p1();
[~,U_pid,Y_pid] = systemSim(controller, obj, y_zad, 0.5, SIM_LENGHT+0.5);

figure()
hold on
stairs(y_zad)
stairs(Y_dmc)
hold off
figure()
stairs(U_dmc)

figure()
hold on
stairs(y_zad)
stairs(Y_pid)
hold off
figure()
stairs(U_pid)

err = norm(y_zad-Y_dmc);
disp(err);