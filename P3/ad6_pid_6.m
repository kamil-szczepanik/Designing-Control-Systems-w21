clear;
close all; 
global T MV_MIN MV_MAX dMV_MIN dMV_MAX SIM_LENGTH y_zad
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

options = optimoptions(@ga,'MaxGenerations',300,'PopulationSize',...
    90,'TimeLimit',300,'MutationFcn', {@mutationadaptfeasible, 0.8, 0.9});
params = ga(@f,18,[],[],[],[],...
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],...
    [1,8,3,1,8,3,1,8,3,1,8,3,1,8,3,1,8,3],...
    [],[],options);

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

controllers = {PID(params(1), params(2), params(3), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               PID(params(4), params(5), params(6), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               PID(params(7), params(8), params(9), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               PID(params(10), params(11), params(12), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               PID(params(13), params(14), params(15), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               PID(params(16), params(17), params(18), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)};

FuzzyPID = Fuzzy(weights, controllers);         
obj = Obj_15Y_p3();

[~, u,y] = systemSimFuzzy(FuzzyPID, obj, y_zad,T, SIM_LENGTH+0.5);

figure()
hold on
fig = stairs(y_zad);
writematrix([fig.XData; fig.YData]','txts/ad6_pid_6_y_zad.txt', "Delimiter","tab");
fig = stairs(y);
writematrix([fig.XData; fig.YData]','txts/ad6_pid_6_y.txt', "Delimiter","tab");
hold off
figure()
hold on
fig = stairs(u);
writematrix([fig.XData; fig.YData]','txts/ad6_pid_6_u.txt', "Delimiter","tab");
hold off
disp(norm(y_zad-y))
save("data/ad6_pid_6_ga.mat")
function loss = f(params)
    global T MV_MIN MV_MAX dMV_MIN dMV_MAX SIM_LENGTH y_zad
    
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

    controllers = {PID(params(1), params(2), params(3), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
                   PID(params(4), params(5), params(6), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
                   PID(params(7), params(8), params(9), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
                   PID(params(10), params(11), params(12), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
                   PID(params(13), params(14), params(15), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
                   PID(params(16), params(17), params(18), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)};

    FuzzyPID = Fuzzy(weights, controllers);         
    obj = Obj_15Y_p3();
    
    [~, ~,y] = systemSimFuzzy(FuzzyPID, obj, y_zad,T, SIM_LENGTH+0.5);
    loss = norm(y_zad-y);
end