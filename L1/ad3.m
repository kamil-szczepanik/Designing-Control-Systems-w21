close
clear
global S Td
load("u75.mat");
S = u75;
S = (S(1:i75)-S(1))/(75 - 25);
params = zeros(10,3);
loss = zeros(10,1);
for k = 0:1:9
    Td = k;
    clc;
    fprintf("%d/10",k);
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
[~, ~,Sm] = systemSim(@(y,y_zad)1, obj, 1, 1, i75);
hold on
stairs(S);
stairs(Sm);
hold off

save("model", "Sm", "K", "T1", "T2", "Td");
function loss = f(params)
    global S Td
    i = 317;
    T1 = params(1);
    T2 = params(2);
    K = params(3);
	obj = double_inertial(K,Td,T1,T2);
    [~, ~,y] = systemSim(@(y,y_zad)1, obj, 1, 1, i);
    loss = norm(S-y);
end