clear;
close all;
load("model.mat");
load("PID_zn.mat");
SIM_LENGHT = 500;
y_zad = zeros(SIM_LENGHT*2,1) + 1.5;

fprintf("Reguła Zieglera-Nicholsa:\n\tK: %0.3f\n\tTi: %0.3f\n\tTd: %0.3f\n", K_pid, Ti_pid, Td_pid);
controller = PID(K_pid, Ti_pid, Td_pid, 0.5, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p1();
[~,U_pid_zn,Y_pid_zn] = systemSim(controller, obj, y_zad, 0.5, SIM_LENGHT+0.5);

K_pid = Kk/2.2;
Ti_pid = 2.2*Tk;
Td_pid = Tk/6.3;
fprintf("Reguła  Tyreusa-Luybena:\n\tK: %0.3f\n\tTi: %0.3f\n\tTd: %0.3f\n", K_pid, Ti_pid, Td_pid);
controller = PID(K_pid, Ti_pid, Td_pid, 0.5, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
obj = Obj_15Y_p1();
[~,U_pid_tl,Y_pid_tl] = systemSim(controller, obj, y_zad, 0.5, SIM_LENGHT+0.5);


figure()
hold on
stairs(y_zad)
stairs(Y_pid_zn)
hold off
figure()
hold on
stairs(y_zad)
stairs(Y_pid_tl)
hold off