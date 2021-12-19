clear;
close all; 
LAMBDA = [20,1,1,10,20];
D = 300;
N1 = 8;
N2 = 11;
N3 = 11;
N4 = 14;
N5 = 15;
Nu1 = 2;
Nu2 = 2;
Nu3 = 3;
Nu4 = 5;
Nu5 = 6;
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

sig_y1 = bell_weight([7/6,1, 0.3333]);
sig_y2 = bell_weight([7/6,1, 2.6667]);
sig_y3 = bell_weight([7/6,1, 5]);
sig_y4 = bell_weight([7/6,1, 7.3333]);
sig_y5 = bell_weight([7/6,1, 9.6667]);
weights = {@(u,y) sig_y1(y)
            @(u,y) sig_y2(y)
            @(u,y) sig_y3(y)
            @(u,y) sig_y4(y)
            @(u,y) sig_y5(y)};


controllers = {DMC(step_response_15(0.1111,1), LAMBDA(1), N1, Nu1, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.4141,1), LAMBDA(2), N2, Nu2, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.6162,1), LAMBDA(3), N3, Nu3, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.7576,1), LAMBDA(4), N4, Nu4, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.8788,1), LAMBDA(5), N5, Nu5, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)};

FuzzyDMC = Fuzzy(weights, controllers);         
obj = Obj_15Y_p3();

[~, u,y] = systemSimFuzzy(FuzzyDMC, obj, y_zad,T, SIM_LENGTH+0.5);
figure(1)
fig = stairs(y);

figure(1)
stairs(y, "MarkerSize",10);
hold on
stairs(y_zad, "--");
figure(2);
stairs(u);
hold on

figure(1)
legend("y","y_zad")
matlab2tikz('tex/ad7_dmc_5_y.tex','showInfo', false);

figure(2)
matlab2tikz('tex/ad7_dmc_5_u.tex','showInfo', false);
disp(norm(y_zad-y))