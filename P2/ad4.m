clear;
close all;
load("data/S_u.mat");
SIM_LENGHT = 500;

y_zad = zeros(SIM_LENGHT*2,1);
y_zad(200:SIM_LENGHT*2) = 1.5;
y_zad(500:800) = 2.5;
y_zad(800:1000) = 2;


controller = DMC(s, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p1();
[~,U,Y] = systemSim(controller, obj, y_zad, 0.5, SIM_LENGHT+0.5);

figure()
hold on
stairs(y_zad)
stairs(Y)
hold off
figure()
stairs(U)

err = norm(y_zad-Y);
disp(err);