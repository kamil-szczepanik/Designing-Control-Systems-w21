clear all
close all

%% Pomiary: skok u1
load('odp_skok_u1_25_75.mat')
y1_1 = y1;
y2_1 = y2;
step_u1 = u1;

figure()
hold on
fig = stairs(y1_1(66:end));
writematrix([fig.XData; fig.YData]','txts/ad4_y1_1.txt', "Delimiter","tab");
hold off
figure()
hold on
fig = stairs(y2_1(66:end));
writematrix([fig.XData; fig.YData]','txts/ad4_y2_1.txt', "Delimiter","tab");
hold off
figure()
hold on
fig = stairs(step_u1(66:end));
writematrix([fig.XData; fig.YData]','txts/ad4_u1.txt', "Delimiter","tab");
hold off

%% Pomiary: skok u2
load('odp_skok_u2_30_80.mat')
y1_2 = y1;
y2_2 = y2;
step_u2 = u2;

figure()
hold on
fig = stairs(y1_2(42:end));
writematrix([fig.XData; fig.YData]','txts/ad4_y1_2.txt', "Delimiter","tab");
hold off
figure()
hold on
fig = stairs(y2_1(42:end));
writematrix([fig.XData; fig.YData]','txts/ad4_y2_2.txt', "Delimiter","tab");
hold off
figure()
hold on
fig = stairs(step_u2(42:end));
writematrix([fig.XData; fig.YData]','txts/ad4_u2.txt', "Delimiter","tab");
hold off

%% Przeksztalcenie odpowiedzi skokowej
S = step_response(y1_1, y2_1, y1_2, y2_2, step_u1, step_u2);
save("data/model","S");




