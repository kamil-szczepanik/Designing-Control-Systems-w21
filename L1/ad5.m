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
lambda = 0.5;
N = 100;
Nu = 100;
MV_MIN = 0;
MV_MAX = 100;
dMV_MIN = 0;
dMV_MAX = 100;


controller = DMC(S, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)

obj = double_inertial(K,Td,T1,T2);
[~, ~,y] = systemSim(@controller, obj, 1, 1, i);
disp(norm(S-y));
hold on
stairs(S);
stairs(y);
hold off
