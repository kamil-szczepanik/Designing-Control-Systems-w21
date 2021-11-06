close;
load("u75.mat");
S = measurements;
S = (S(1:i)-S(1))/(75 - 25);

% Wyznaczone parametry z ad3
T = [81.8655718541154,4.66366201223322,0.305562434489639];
Td = 8;

K = T(3);
T1 = T(1);
T2 = T(2);

S;
lambda = 0.001;%00001;%.001;
N = 300;
Nu = 300;
MV_MIN = 0;
MV_MAX = 100;
dMV_MIN = -10;
dMV_MAX = +10;


controller = DMC(Sm, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
%controller = @(e)DMC_old(e, Sm, lambda, N, Nu, MV_MIN, MV_MAX);

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
