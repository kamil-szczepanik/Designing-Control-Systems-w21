clear;
disp('Zadanie 1:')
obj = Obj_15Y_p1();

controller =  PID(K_pid, Ti_pid, 12, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
[~,~,Y] = systemSim(@(e)1.2, obj, 0, 1, 500);

    options = optimoptions(@fminunc,'MaxIterations',1000,'MaxFunctionEvaluations',2000);
    [params(k+1,:),loss(k+1)] = fminunc(@f,[80,40,0.3],options);

    

    
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