close all;
clear;
clc;
global T MV_MIN MV_MAX dMV_MIN dMV_MAX K Td T1 T2 Y0 freq_noise white_noise;
T=1; MV_MIN=-1; MV_MAX=1; dMV_MIN=-2; dMV_MAX=2;
K=1; Td=0; T1=5; T2=1; Y0=0; freq_noise=0;
white_noise = false;

options = optimoptions(@ga,'MaxGenerations',800,'MaxStallGenerations',10,'PopulationSize', 100);
params = ga(@f,3,[],[],[],[],[0.000001,0.000001,0.000001],[20,20,20],[],options);

K_pid=params(1);
Ti_pid=params(2);
Td_pid=params(3);


controller = PID(K_pid, Ti_pid, Td_pid, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);


obj = double_inertial(K, Td, T1, T2, Y0, freq_noise);

y_zad = ones(600,1)*0.7;


[~, u,y] = systemSim(controller, obj, y_zad, 1, 600, white_noise); % @(x)1
disp(norm(y_zad-y));

figure(2)
stairs(u);
figure(1)
hold on
yline(1);
stairs(y);
hold off


function loss = f(params)
    global T MV_MIN MV_MAX dMV_MIN dMV_MAX K Td T1 T2 Y0 freq_noise white_noise;
    K_pid=params(1);
    Ti_pid=params(2);
    Td_pid=params(3);

    controller1 = PID(K_pid, Ti_pid, Td_pid, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
    obj1 = double_inertial(K, Td, T1, T2, Y0, freq_noise);
    y_zad = ones(600,1)*0.9;
    [~, u,y] = systemSim(controller1, obj1, y_zad, 1, 600, white_noise); % @(x)1
    loss1 = norm(y_zad-y);
    
    controller2 = PID(K_pid, Ti_pid, Td_pid, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
    obj2 = double_inertial(K, Td, T1, T2, Y0, freq_noise);
    y_zad = ones(600,1)*0.5;
    [~, u,y] = systemSim(controller2, obj2, y_zad, 1, 600, white_noise); % @(x)1
    loss2 = norm(y_zad-y);
    
    controller3 = PID(K_pid, Ti_pid, Td_pid, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
    obj3 = double_inertial(K, Td, T1, T2, Y0, freq_noise);
    y_zad = ones(600,1)*0.2;
    [~, u,y] = systemSim(controller3, obj3, y_zad, 1, 600, white_noise); % @(x)1
    loss3 = norm(y_zad-y);
    
    loss = loss1 + loss2 + loss3
end