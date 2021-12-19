clear;
close all; 

set(0,'defaulttextinterpreter','latex');
set(0,'DefaultLineLineWidth',1);
set(0,'DefaultStairLineWidth',1);
L = 1;
LAMBDA = [70,70];
D = 300;
N1 = 8;
N2 = 7;
Nu1 = 2;
Nu2 = 3;
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

sig_y1 = bell_weight([2.3333,1,2.6667]);
sig_y2 = bell_weight([2.3333,1,7.3333]);
weights = {@(u,y) sig_y1(y)
            @(u,y) sig_y2(y)};

controllers = {DMC(step_response_15(0.41,1), LAMBDA(1), N1, Nu1, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.757,1), LAMBDA(2), N2, Nu2, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)};

FuzzyDMC = Fuzzy(weights, controllers);         
obj = Obj_15Y_p3();

[~, u,y] = systemSimFuzzy(FuzzyDMC, obj, y_zad,T, SIM_LENGTH+0.5);

figure(1)
stairs(y, "MarkerSize",10);
hold on
stairs(y_zad, "--");
figure(2);
stairs(u);
hold on

figure(1)
legend("y","y_zad")
matlab2tikz('tex/ad7_dmc_2_y.tex','showInfo', false);

figure(2)
matlab2tikz('tex/ad7_dmc_2_u.tex','showInfo', false);



disp(norm(y_zad-y))

% controllers = {DMC(step_response_15(0.41,1), L, N1, Nu1, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
%                DMC(step_response_15(0.757,1), L, N2, Nu2, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)};
% 
% FuzzyDMC = Fuzzy(weights, controllers);         
% obj = Obj_15Y_p3();
% 
% [~, u1,y1] = systemSimFuzzy(FuzzyDMC, obj, y_zad,T, SIM_LENGTH+0.5);
% 
% figure(1)
% stairs(y1, "-.", "MarkerSize",1)
% stairs(y_zad, "--");
% figure(2)
% stairs(u1,"-.", "MarkerSize",1)
% 
% 
% % save("data/ad4_pid_2_ga.mat")
% 
