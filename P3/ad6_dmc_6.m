clear;
close all; 
LAMBDA = [1,1,1,1,1,1];
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


controllers = {DMC(step_response_15(-0.0505,1), LAMBDA(1), N1, Nu1, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.3535,1), LAMBDA(2), N2, Nu2, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.5354,1), LAMBDA(3), N3, Nu3, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.6768,1), LAMBDA(4), N4, Nu4, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.798,1), LAMBDA(5), N5, Nu5, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.899,1), LAMBDA(6), N6, Nu6, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)};

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
matlab2tikz('tex/ad7_dmc_6_y.tex','showInfo', false);

figure(2)
matlab2tikz('tex/ad7_dmc_6_u.tex','showInfo', false);
disp(norm(y_zad-y))