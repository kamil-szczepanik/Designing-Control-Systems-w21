clear;
% close all; 
LAMBDA = 1;
D = 301;
N = D;
Nu = D;
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


controllers = {DMC(step_response_15(-0.0505,1), LAMBDA, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.3535,1), LAMBDA, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.5354,1), LAMBDA, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.6768,1), LAMBDA, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.798,1), LAMBDA, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.899,1), LAMBDA, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)};

FuzzyDMC = Fuzzy(weights, controllers);         
obj = Obj_15Y_p3();

[~, u,y] = systemSimFuzzy(FuzzyDMC, obj, y_zad,T, SIM_LENGTH+0.5);

figure(1)
stairs(y_zad, "--");
hold on
stairs(y);
hold off
% figure(2)
% stairs(u);
disp(norm(y_zad-y))
% save("data/ad4_pid_2_ga.mat")