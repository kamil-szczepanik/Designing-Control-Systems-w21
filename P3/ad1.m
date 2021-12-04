clear;
close all;
symulacja_obiektu15y_p3(0,0,0,0)
SIM_LENGHT = 500;
Y = zeros(SIM_LENGHT,1);
U = zeros(SIM_LENGHT,1);
Z = zeros(SIM_LENGHT,1);
STEP_MOMENT = 30;
for k=STEP_MOMENT:SIM_LENGHT
    Y(k) = symulacja_obiektu15y_p3(U(k-5), ...
        U(k-6),Y(k-1), Y(k-2));
end
fig = stairs(Y);
grid;

writematrix([fig.XData; fig.YData]', 'txts/ad1.txt', "Delimiter","tab");