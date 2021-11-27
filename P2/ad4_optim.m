clear;
close all;
global MV_MIN MV_MAX dMV_MIN dMV_MAX s S_z;
load("data/S_u_full.mat");
load("data/S_z_full.mat");

MV_MIN = -Inf;
MV_MAX = Inf;
dMV_MIN = -Inf;
dMV_MAX = Inf;
s = S_u;

options = optimoptions(@fminunc,'MaxIterations',100,'MaxFunctionEvaluations',200);
[params,loss] = fminunc(@f,[205,50,10,1],options);

D = params(1);
N = max(params(2),D);
Nu = max(params(3),N);
lambda = params(4);

controller = DMCz(s(1:D),S_z, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p2();
[~, u,y] = systemSimZ(controller, obj, y_zad, 0, 0.5, SIM_LENGHT+0.5);
figure()
hold on
y_zad_fig = stairs(y_zad)
y_fig = stairs(y)
hold off
figure()
u_fig = stairs(u)

fprintf("Wynik optymalizacji:\n\tN: %0.3f\n\tNu: %0.3f\n\tN: %0.3f\n\tlambda: %0.3f\n\tloss: %0.4f\n", N, Nu, D,lambda, norm(y_zad(200:end)-y(200:end)));

figs = [u_fig, y_zad_fig y_fig];
fig_names = ["u" "y_zad" "y"];
for i = 1:size(figs,2)
    writematrix([figs(i).XData; figs(i).YData]', "txts/p2_zadanie6_DMC"+fig_names(i)+".txt", 'Delimiter','tab')
end

function loss = f(params)
    global MV_MIN MV_MAX dMV_MIN dMV_MAX s S_z;
    SIM_LENGHT = 500;
    y_zad = zeros(SIM_LENGHT*2,1);
    y_zad(200:SIM_LENGHT*2) = 1.5;
    y_zad(500:800) = 2.5;
    y_zad(800:1000) = 2;
    
    D = params(1);
    N = max(params(2),D);
    Nu = max(params(3),N);
    lambda = params(4);
    
    controller = DMCz(s(1:D+1),S_z, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
    obj = Obj_15Y_p2();
    [~, ~,y] = systemSimZ(controller, obj, y_zad, 0, 0.5, SIM_LENGHT+0.5);
    loss = norm(y_zad-y);
end