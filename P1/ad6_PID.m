clear;
close all;
global MV_MIN MV_MAX dMV_MIN dMV_MAX;
load("PID_ad5.mat");

options = optimoptions(@fminunc,'MaxIterations',100,'MaxFunctionEvaluations',200);
[params,loss] = fminunc(@f,[K_pid, Ti_pid, Td_pid],options);
%  options = optimoptions(@ga,'MaxGenerations',800,'MaxStallGenerations',100,'PopulationSize', 100);
% params = ga(@f,3,options);

K = params(1);
Ti = params(2);
Td = params(3);

SIM_LENGHT = 500;
y_zad = zeros(SIM_LENGHT*2,1);
y_zad(200:500) = 1.5;
y_zad(500:800) = 2.5;
y_zad(800:1000) = 2;

controller = PID(K, Ti, Td, 0.5, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p1();
[~, u,y] = systemSim(controller, obj, y_zad, 0.5, SIM_LENGHT+0.5);

fprintf("Wynik optymalizacji:\n\tK: %0.3f\n\tTi: %0.3f\n\tTd: %0.3f\n\tloss: %0.4f\n", K, Ti, Td, norm(y_zad(200:end)-y(200:end)));
figure()
u_fig = stairs(u)
figure()
hold on
y_zad_fig = stairs(y_zad)
y_fig = stairs(y)
hold off

figs = [u_fig y_zad_fig y_fig];
fig_names = ["u","y_zad","y_fig"];
for i = 1:size(figs,2)
    writematrix([figs(i).XData; figs(i).YData]', "p1_zadanie6_PID"+fig_names(i)+".txt", 'Delimiter','tab')
end


function loss = f(params)
    global MV_MIN MV_MAX dMV_MIN dMV_MAX;
    K = params(1);
    Ti = params(2);
    Td = params(3);
    SIM_LENGHT = 500;
    y_zad = zeros(SIM_LENGHT*2,1);
    y_zad(200:SIM_LENGHT*2) = 1.5;
    y_zad(500:800) = 2.5;
    y_zad(800:1000) = 2;
    
    controller = PID(K, Ti, Td, 0.5, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
    obj = Obj_15Y_p1();
    [~, ~,y] = systemSim(controller, obj, y_zad, 0.5, SIM_LENGHT+0.5);
    loss = norm(y_zad-y);
end