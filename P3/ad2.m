clear;
close all;
U_zad_zmiany = [-1,-0.5,-0.25,0.25,0.5,1];
SIM_LENGHT = 500;
Y = zeros(SIM_LENGHT,1);
U = zeros(SIM_LENGHT,1);
Z = zeros(SIM_LENGHT,1);

STEP_MOMENT = 30;
file_index = 0;
for p=1:length(U_zad_zmiany)
    U(STEP_MOMENT:end) = U_zad_zmiany(p);
    for k=STEP_MOMENT:SIM_LENGHT
        Y(k) = symulacja_obiektu15y_p3(U(k-5), ...
            U(k-6),Y(k-1), Y(k-2));
    end
    figure(1);
    hold on
    grid on
    fig = stairs(Y);
    hold off
    writematrix([fig.XData; fig.YData]',['txts/ad2_wej_wyj_', num2str(p),'.txt'], "Delimiter","tab");

    figure(2);
    hold on
    grid on
    fig = stairs(U);
    hold off
    writematrix([fig.XData; fig.YData]',['txts/ad2_wej_wyj_u_', num2str(p),'.txt'], "Delimiter","tab");
end
save('data/step_2')
% Charakterystyka statyczna

Y_stat = zeros(100,1);
U_zad = linspace(-1, 1, 100)';
for i = 1:length(U_zad)
    [Y, U] = get_YU(0, U_zad(i), SIM_LENGHT, STEP_MOMENT);
    Y_stat(i)= Y(SIM_LENGHT);
end
fig = plot(U_zad, Y_stat);
writematrix([fig.XData; fig.YData]','txts/ad2_char_stat.txt', "Delimiter","tab");


function [Y, U] = get_YU(U_pp, U_zad, sim_lenght, step_moment)
    Y = zeros(sim_lenght,1);
    U = zeros(sim_lenght,1);
    U(:) = U_pp;
    U(step_moment:end) = U_zad;
    for k=30:sim_lenght
        Y(k) = symulacja_obiektu15y_p3(U(k-5), ...
        U(k-6),Y(k-1), Y(k-2));
    end
end