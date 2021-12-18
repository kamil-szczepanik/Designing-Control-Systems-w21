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

% 
% options = optimoptions(@fminunc,'MaxIterations',1000,'MaxFunctionEvaluations',2000);
% [params,loss] = fminunc(@f,[20,20,5,12,20,20,-2,5,0.1026,3.1314,1.3555,0.1026,3.1314,1.3555],options);

options = optimoptions(@ga,'MaxGenerations',300,'PopulationSize', 50,'TimeLimit',300,'MutationFcn', {@mutationadaptfeasible, 0.8, 0.9});
params = ga(@f,14,[0,0,1,-1,0,0,0,0,0,0,0,0,0,0;0,0,0,0,0,0,1,-1,0,0,0,0,0,0;0,0,0,1,0,0,-1,0,0,0,0,0,0,0],[0,0,0],[],[],[0,0,-2,-2,0,0,-2,-2,0,0,0,0,0,0],[10,10,12,12,10,10,12,12,1,10,3,1,10,3],[],[],options);
% params = [20,20,5,12,20,20,-2,5,0.08,3,2,0.08,3,0];
sig_y1 = sigmoid_weight([params(1),params(2)], [params(3),params(4)]);
sig_y2 = sigmoid_weight([params(5),params(6)], [params(7),params(8)]);
weights = {@(u,y) sig_y1(y)
            @(u,y) sig_y2(y)};

controllers = {PID(params(9), params(10), params(11), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               PID(params(12), params(13), params(14), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)};

FuzzyPID = Fuzzy(weights, controllers);         
obj = Obj_15Y_p3();

[~, u,y] = systemSimFuzzy(FuzzyPID, obj, y_zad,T, SIM_LENGTH+0.5);

figure()
hold on
fig = stairs(y_zad);
fig = stairs(y);
hold off
figure()
hold on
fig = stairs(u);
hold off
disp(norm(y_zad-y))
save("data/ad4_pid_2_ga.mat")
function loss = f(params)
    global T MV_MIN MV_MAX dMV_MIN dMV_MAX SIM_LENGTH y_zad
    
    sig_y1 = sigmoid_weight([params(1),params(2)], [params(3),params(4)]);
    sig_y2 = sigmoid_weight([params(5),params(6)], [params(7),params(8)]);
    weights = {@(u,y) sig_y1(y)
                @(u,y) sig_y2(y)};

    controllers = {PID(params(9), params(10), params(11), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
                   PID(params(12), params(13), params(14), T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)};

    FuzzyPID = Fuzzy(weights, controllers);         
    obj = Obj_15Y_p3();
    
    [~, ~,y] = systemSimFuzzy(FuzzyPID, obj, y_zad,T, SIM_LENGTH+0.5);
    loss = norm(y_zad-y);
end