clear;
close all;
global MV_MIN MV_MAX dMV_MIN dMV_MAX D N Nu s;
load("DMC_ad5.mat");
load("model.mat");
SIM_LENGHT = 500;
y_zad = zeros(SIM_LENGHT*2,1);
y_zad(200:SIM_LENGHT*2) = 1.5;
y_zad(500:800) = 2.5;
y_zad(800:1000) = 2; 
lambda = 0.1;
N = size(s,1);
Nu = N;

D = 125;
controller = DMC(s(1:D+1), lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p1();
[~, ~,y] = systemSim(controller, obj, y_zad, 0.5, SIM_LENGHT+0.5);
loss = norm(y_zad - y);

% N
N_vec = NaN(D,1);
N = D;
tol = 0.0001;
loss_max = loss + tol;
while loss <= loss_max
    N = N - 1; 
    controller = DMC(s(1:D+1), lambda, N, N, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
    obj = Obj_15Y_p1();
    [~, ~,y] = systemSim(controller, obj, y_zad, 0.5, SIM_LENGHT+0.5);
    loss = norm(y_zad - y);
    N_vec(N) = loss;
end
N = N + 1;
figure()
plot(N_vec)

% Nu
Nu_vec = NaN(N,1);
Nu = N;
tol = 0.0001;
loss = N_vec(N);
loss_max = loss + tol;
while loss <= loss_max
    Nu = Nu - 1; 
    controller = DMC(s(1:D+1), lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
    obj = Obj_15Y_p1();
    [~, u,y] = systemSim(controller, obj, y_zad, 0.5, SIM_LENGHT+0.5);
    loss = norm(y_zad - y);
    Nu_vec(Nu) = loss;
end
Nu = Nu + 1;
figure()
plot(Nu_vec)



options = optimoptions(@fminunc,'MaxIterations',100,'MaxFunctionEvaluations',200);
[lambda,loss] = fminunc(@f,0.1,options);

figure()
u_fig = stairs(u)
figure()
hold on
y_zad_fig = stairs(y_zad)
y_fig = stairs(y)
hold off

fprintf("Wynik optymalizacji:\n\tN: %0.3f\n\tNu: %0.3f\n\tN: %0.3f\n\tlambda: %0.3f\n\tloss: %0.4f\n", N, Nu, D,lambda, norm(y_zad(200:end)-y(200:end)));

figs = [u_fig, y_zad_fig y_fig];
fig_names = ["u" "y_zad" "y"];
for i = 1:size(figs,2)
    writematrix([figs(i).XData; figs(i).YData]', "p1_zadanie6_DMC"+fig_names(i)+".txt", 'Delimiter','tab')
end


function loss = f(lambda)
    global MV_MIN MV_MAX dMV_MIN dMV_MAX N Nu D s;
    SIM_LENGHT = 500;
    y_zad = zeros(SIM_LENGHT*2,1);
    y_zad(200:SIM_LENGHT*2) = 1.5;
    y_zad(500:800) = 2.5;
    y_zad(800:1000) = 2;
    
    controller = DMC(s(1:D+1), lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
    obj = Obj_15Y_p1();
    [~, ~,y] = systemSim(controller, obj, y_zad, 0.5, SIM_LENGHT+0.5);
    loss = norm(y_zad-y);
end