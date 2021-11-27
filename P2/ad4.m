clear;
close all;
load("data/S_u.mat");
load("data/S_z.mat");
SIM_LENGHT = 500;

y_zad = zeros(SIM_LENGHT*2,1);
y_zad(200:SIM_LENGHT*2) = 1.5;
y_zad(500:800) = 2.5;
y_zad(800:1000) = 2;
z_zad = 0;

D = size(S_u,1);
lambda = 5;
N = D;
Nu = D;
MV_MIN = -Inf;
MV_MAX = Inf;
dMV_MIN = -Inf;
dMV_MAX = Inf;

controller = DMCz(S_u,S_z, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p2();
[~,U,Y] = systemSimZ(controller, obj, y_zad,z_zad, 0.5, SIM_LENGHT+0.5);

figure()
hold on
stairs(y_zad)
stairs(Y)
hold off
figure()
stairs(U)

err = norm(y_zad-Y);
disp(err);