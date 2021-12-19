clear;
% close all; 
LAMBDA = 1;
D = 301;
N1 = 21;
N2 = 14;
N3 = 15;
N4 = 11;
N5 = 9;
N6 = 11;
Nu1 = 2;
Nu2 = 2;
Nu3 = 4;
Nu4 = 2;
Nu5 = 3;
Nu6 = 2;
T = 0.5;
MV_MIN = -1;
MV_MAX = 1;
dMV_MIN = -2;
dMV_MAX = 2;
SIM_LENGTH = 400;
y_zad = zeros(SIM_LENGTH*2,1);
y_zad(200:400) = 10;
y_zad(400:600) = 4;
y_zad(600:800) = -0.1;

sig_y1 = bell_weight([1,1,0]);
sig_y2 = bell_weight([1,1,2]);
sig_y3 = bell_weight([1,1,4]);
sig_y4 = bell_weight([1,1,6]);
sig_y5 = bell_weight([1,1,8]);
sig_y6 = bell_weight([1,1,10]);
weights = {@(u,y) sig_y1(y)
            @(u,y) sig_y2(y)
            @(u,y) sig_y3(y)
            @(u,y) sig_y4(y)
            @(u,y) sig_y5(y)
            @(u,y) sig_y6(y)};


controllers = {DMC(step_response_15(-0.0505,1), LAMBDA, N1, Nu1, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.3535,1), LAMBDA, N2, Nu2, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.5354,1), LAMBDA, N3, Nu3, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.6768,1), LAMBDA, N4, Nu4, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.798,1), LAMBDA, N5, Nu5, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.899,1), LAMBDA, N6, Nu6, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)};

FuzzyDMC = Fuzzy(weights, controllers);         
obj = Obj_15Y_p3();

[~, u,y] = systemSimFuzzy(FuzzyDMC, obj, y_zad,T, SIM_LENGTH+0.5);
figure(1)
fig = stairs(y);
writematrix([fig.XData; fig.YData]','txts/ad6_dmc_6_y.txt', "Delimiter","tab");

hold on
fig = stairs(y_zad, "--");
writematrix([fig.XData; fig.YData]','txts/ad6_dmc_6_yzad.txt', "Delimiter","tab");

hold off
figure(2)
fig = stairs(u);
writematrix([fig.XData; fig.YData]','txts/ad6_dmc_6_u.txt', "Delimiter","tab");

disp(norm(y_zad-y))
% save("data/ad4_pid_2_ga.mat")