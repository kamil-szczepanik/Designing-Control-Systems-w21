% close all;
% clear;
% clc;
% space = 600;
% f=10;
% a = space/f;
% x = linspace(-pi,pi,a);
% y = zeros(1,600);
% for i = 1:space
%     y(i) = sin(x(mod(i,a)+1));
% end
% 
% plot(y)
% 
% load("data/model.mat");
% load("data/PID_SIM.mat");
% obj = double_inertial(K,Td,T1,T2,20.9700);
% obj(0.2)

options = optimoptions(@ga,'MaxGenerations',800,'MaxStallGenerations',15,'PopulationSize', 100);
params = ga(@f,3,[],[],[],[],[0.0001,0.0001,0.0001],[10,10,10],[],options);

function loss = f(params)
%     global MV_MIN MV_MAX dMV_MIN dMV_MAX s S_z;
%     SIM_LENGHT = 500;
%     y_zad = zeros(SIM_LENGHT*2,1);
%     y_zad(200:SIM_LENGHT*2) = 1.5;
%     y_zad(500:800) = 2.5;
%     y_zad(800:1000) = 2;
%     
%     D = params(1);
%     N = params(2);
%     Nu = params(3);
% %     N = max(params(2),D);
% %     Nu = max(params(3),N);
%     lambda = params(4);
%     
%     controller = DMCz(s(1:D),S_z, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
%     obj = Obj_15Y_p2();
%     [~, ~,y] = systemSimZ(controller, obj, y_zad, 0, 0.5, SIM_LENGHT+0.5);
%     
    K_pid=params(1);
    Ti_pid=params(2);
    Td_pid=params(3);
    T=1; MV_MIN=-1; MV_MAX=1; dMV_MIN=-2; dMV_MAX=2;

    controller = PID(K_pid, Ti_pid, Td_pid, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);

    K=1; Td=0; T1=5; T2=1; Y0=0; freq_noise=0;
    obj = double_inertial(K, Td, T1, T2, Y0, freq_noise);

    y_zad = ones(600,1)*0.7;

    white_noise = false;
    [~, u,y] = systemSim(controller, obj, y_zad, 1, 600, white_noise); % @(x)1
    loss = norm(y_zad-y)
end