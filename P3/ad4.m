close all;
clear;
global T MV_MIN MV_MAX dMV_MIN dMV_MAX SIM_LENGTH y_zad
T = 0.5;
MV_MIN = -1;
MV_MAX = 1;
dMV_MIN = -inf;
dMV_MAX = inf;
SIM_LENGTH = 400;
y_zad = zeros(SIM_LENGTH*2,1);
y_zad(200:400) = 10;
y_zad(400:600) = 4;
y_zad(600:800) = -0.1;

options = optimoptions(@ga,'MaxGenerations',300,'MaxStallGenerations',200,'PopulationSize', 300);
params = ga(@f,3,[],[],[],[],[],[],[],[],options);
%     options = optimoptions(@fminunc,'MaxIterations',1000,'MaxFunctionEvaluations',2000);
% [params,loss] = fminunc(@f,[1,1000,0.1],options);

K = params(1);
Ti = params(2);
Td = params(3);
obj = Obj_15Y_p3();
controller = PID(K, Ti, Td, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
[~, u,y] = systemSim(controller, obj, y_zad,0.5, SIM_LENGTH+0.5);
figure()
hold on
fig = stairs(y_zad);
writematrix([fig.XData; fig.YData]','txts/ad4_y_zad.txt', "Delimiter","tab");
fig = stairs(y);
writematrix([fig.XData; fig.YData]','txts/ad4_y.txt', "Delimiter","tab");
hold off
figure()
hold on
fig = stairs(u);
writematrix([fig.XData; fig.YData]','txts/ad4_u.txt', "Delimiter","tab");
hold off
save("data/ad4_PID");
function loss = f(params)
    global T MV_MIN MV_MAX dMV_MIN dMV_MAX SIM_LENGTH y_zad
    K = params(1);
    Ti = params(2);
    Td = params(3);
	obj = Obj_15Y_p3();
    controller = PID(K, Ti, Td, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
    [~, ~,y] = systemSim(controller, obj, y_zad,0.5, SIM_LENGTH+0.5);
    loss = norm(y_zad-y);
end