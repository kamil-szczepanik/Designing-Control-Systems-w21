close all;
clear;

K_pid=5; Ti_pid=inf; Td_pid=0; T=1; MV_MIN=-1; MV_MAX=1; dMV_MIN=-2; dMV_MAX=2;

controller = PID(K_pid, Ti_pid, Td_pid, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);

K=1; Td=0; T1=5; T2=1; Y0=0; freq_noise=0;
obj = double_inertial(K, Td, T1, T2, Y0, freq_noise);

y_zad = ones(600,1);

white_noise = false;
[~, u,y] = systemSim(controller, obj, y_zad, 1, 600, white_noise); % @(x)1
disp(norm(y_zad-y));

figure(2)
stairs(u);
figure(1)
hold on
yline(1);
stairs(y);
hold off
