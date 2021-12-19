clear;
close all; 
LAMBDA = [30,20,10,1];
D = 30;
N1 = 11;
N2 = 11;
N3 = 10;
N4 = 11;
Nu1 = 3;
Nu2 = 2;
Nu3 = 3;
Nu4 = 2;
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

sig_y1 = bell_weight([1.4, 1, 0.8000]);
sig_y2 = bell_weight([1.4,1, 3.6000]);
sig_y3 = bell_weight([1.4,1,6.4000]);
sig_y4 = bell_weight([1.4,1,9.2000]);
weights = {@(u,y) sig_y1(y)
            @(u,y) sig_y2(y)
            @(u,y) sig_y3(y)
            @(u,y) sig_y4(y)};


controllers = {DMC(step_response_15(0.2121,1), LAMBDA(1), N1, Nu1, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.4949,1), LAMBDA(2), N2, Nu2, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.697,1), LAMBDA(3), N3, Nu3, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               DMC(step_response_15(0.8586,1), LAMBDA(4), N4, Nu4, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)};

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
matlab2tikz('tex/ad7_dmc_4_y.tex','showInfo', false);

figure(2)
matlab2tikz('tex/ad7_dmc_4_u.tex','showInfo', false);
disp(norm(y_zad-y))