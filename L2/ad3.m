close
clear
global S Td i50
load("data/u25_z50.mat");
S = u25_z50;
S = (S(1:i50)-S(1))/(50 - 0);
params = zeros(10,3);
loss = zeros(10,1);
for k = 0:1:14
    Td = k;
    fprintf("%d/15",k);
    options = optimoptions(@fminunc,'MaxIterations',1000,'MaxFunctionEvaluations',2000);
    [params(k+1,:),loss(k+1)] = fminunc(@f,[80,40,0.3],options);
end
clc;
[~,ind] = min(loss);
params = params(ind,:);
Td = ind-1;
T1 = params(1);
T2 = params(2);
K = params(3);
fprintf("Loss: %0.4f\nK: %0.2f\nTd: %0.2f\nT1: %0.2f\nT2: %0.2f\n",loss(ind),K,Td,T1,T2);

obj = double_inertial(K,Td,T1,T2);
[~, ~,Sm] = systemSim(@(y,y_zad)1, obj, 1, 1, i50);
hold on
stairs(S);
stairs(Sm);
hold off

save("data/model_z.mat", "Sm", "K", "T1", "T2", "Td");
function loss = f(params)
    global S Td i50
    i = i50;
    T1 = params(1);
    T2 = params(2);
    K = params(3);
	obj = double_inertial(K,Td,T1,T2);
    [~, ~,y] = systemSim(@(y,y_zad)1, obj, 1, 1, i);
    loss = norm(S-y);
end