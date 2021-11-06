close;
load("model.mat");
lambda = 0.001;
N = 300;
Nu = 300;
MV_MIN = 0;
MV_MAX = 100;
dMV_MIN = -10;
dMV_MAX = +10;


controller = DMC(Sm, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);

obj = double_inertial(K,Td,T1,T2,20.9700);
y_zad = ones(10*i,1);
y_zad(1:5*i,:) = 45;
y_zad(5*i:10*i,:) = 35;
[~, u,y] = systemSim(controller, obj, y_zad, 1, 10*i);

err = norm(y_zad-y)
figure(2)
stairs(u);
figure(1)
hold on
yline(80);
stairs(y);
hold off
