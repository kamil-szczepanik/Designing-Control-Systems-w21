clear;
close all; 
LAMBDA = 1;
D = 300;
N1 = 11;
N2 = 11;
N3 = 10;
Nu1 = 3;
Nu2 = 3;
Nu3 = 3;
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

sig_y1 = bell_weight([1.75,1,1.5]);
sig_y2 = bell_weight([1.75,1,5]);
sig_y3 = bell_weight([1.75,1,8.5]);
weights = {@(u,y) sig_y1(y)
            @(u,y) sig_y2(y)
            @(u,y) sig_y3(y)};


controllers = {DMC(step_response_15(0.3131,1), LAMBDA, N1, Nu1, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.6,1), LAMBDA, N2, Nu2, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.8182,1), LAMBDA, N3, Nu3, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)};

FuzzyDMC = Fuzzy(weights, controllers);         
obj = Obj_15Y_p3();

[~, u,y] = systemSimFuzzy(FuzzyDMC, obj, y_zad,T, SIM_LENGTH+0.5);

% figure(1)
% fig = stairs(y);
% writematrix([fig.XData; fig.YData]','txts/ad6_dmc_3_y.txt', "Delimiter","tab");
% 
% hold on
% fig = stairs(y_zad, "--");
% writematrix([fig.XData; fig.YData]','txts/ad6_dmc_3_yzad.txt', "Delimiter","tab");
% 
% hold off
% figure(2)
% fig = stairs(u);
% writematrix([fig.XData; fig.YData]','txts/ad6_dmc_3_u.txt', "Delimiter","tab");
% 
% 
% figure(1)
% legend("y","y_zad")
% % matlab2tikz('tex/ad6_dmc_3_y.tex','showInfo', false);
% 
% figure(2)
% % matlab2tikz('tex/ad6_dmc_3_u.tex','showInfo', false);
disp(norm(y_zad-y))
% save("data/ad4_pid_2_ga.mat")