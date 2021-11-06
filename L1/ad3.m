close
clear
global S Td
load("u75.mat");
S = measurements;
S = (S(1:i)-S(1))/(75 - 25);
T = zeros(10,3);
loss = zeros(10,1);
for k = 0:1:9
    Td = k;
    options = optimoptions(@fminunc,'MaxIterations',1000,'MaxFunctionEvaluations',2000);
    [T(k+1,:),loss(k+1)] = fminunc(@f,[80,40,0.3],options);
end
[~,ind] = min(loss);
T = T(ind,:);
Td = ind-1;
obj = double_inertial(T(3),Td,T(1),T(2));
[~, ~,y] = systemSim(@(y,y_zad)1, obj, 1, 1, i);
disp(norm(S-y));

hold on
stairs(S);
stairs(y);
hold off
function loss = f(T)
    global S Td
    i = 317;
	obj = double_inertial(T(3),Td,T(1),T(2));
    [~, ~,y] = systemSim(@(y,y_zad)1, obj, 1, 1, i);
    loss = norm(S-y);
end