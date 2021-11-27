clear;
close all;
load("data/S_u.mat");
load("data/S_z.mat");
SIM_LENGHT = 500;

y_zad = zeros(SIM_LENGHT*2,1);
y_zad(200:SIM_LENGHT*2) = 2;
z_zad = zeros(SIM_LENGHT*2,1);
z_zad(500:SIM_LENGHT*2) = 1;

D = size(S_u,1);
lambda = 1;
N = D;
Nu = D;
MV_MIN = -Inf;
MV_MAX = Inf;
dMV_MIN = -Inf;
dMV_MAX = Inf;

controller = DMCz(S_u,S_z, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p2();
[~,Uz_0,Yz_0] = systemSimZ_noise(controller, obj, y_zad,z_zad,0, 0.5, SIM_LENGHT+0.5);

controller = DMCz(S_u,S_z, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p2();
[~,Uz_1,Yz_1] = systemSimZ_noise(controller, obj, y_zad,z_zad,0.1, 0.5, SIM_LENGHT+0.5);

controller = DMCz(S_u,S_z, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p2();
[~,Uz_2,Yz_2] = systemSimZ_noise(controller, obj, y_zad,z_zad,0.2, 0.5, SIM_LENGHT+0.5);

controller = DMC(S_u, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p2();
[~,U,Y] = systemSim(controller, obj, y_zad,z_zad, 0.5, SIM_LENGHT+0.5);

figure()
hold on
stairs(y_zad)
stairs(Yz_0)
stairs(Yz_1)
stairs(Yz_2)
stairs(Y)
hold off
figure()
hold on
stairs(Uz_0)
stairs(Uz_1)
stairs(Uz_2)
stairs(U)
hold off
figure()
stairs(z_zad)

err_z_0 = norm(y_zad-Yz_0);
err_z_1 = norm(y_zad-Yz_1);
err_z_2 = norm(y_zad-Yz_2);
err = norm(y_zad-Y);
disp(err);