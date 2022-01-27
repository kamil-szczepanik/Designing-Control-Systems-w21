close all;
clear;

T=0.1; MV_MIN=-1; MV_MAX=1; dMV_MIN=-2; dMV_MAX=2;
white_noise = true;

load("data/PID_params/przekaznik_white_noise")
controller = PID(K_pid, Ti_pid, Td_pid, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);

K=1; Td=0; T1=5; T2=1; Y0=0;
freq_noise=-1; % freq_noise=-1 => wy³±czono zak³ócenia
SIM_TIME = 600;

obj = double_inertial(K, Td, T1, T2, Y0, SIM_TIME/freq_noise);

val = 0.7;
y_zad = ones(SIM_TIME,1)*val;

[~, u,y] = systemSim(controller, obj, y_zad, 1, SIM_TIME, white_noise); % @(x)1
disp(norm(y_zad-y));

figure(2)
stairs(u);
ylim([-1 1]);
figure(1)
hold on
yline(val);
stairs(y);
ylim([0 1]);
hold off
