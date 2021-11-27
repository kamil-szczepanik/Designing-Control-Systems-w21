clear;
close all;
load("data/u25_z25.mat");
load("data/u25_z50.mat");
load("data/u25_z75.mat");
load("data/u25_z0.mat");

figure(1)
plot([u25_z25,u25_z50,u25_z75]);

grid on
x = [0,25,50,75]';
y = [u25_z0,u25_z25(i25),u25_z50(i50), u25_z75(i75)]';
X = [x.^0, x];
b = (X'*X)\X'*y;
ym = X*b;
disp(b)
figure(2)
hold on
scatter([0,25,50,75], [u25_z0,u25_z25(i25), u25_z50(i50), u25_z75(i75)])
fplot(@(u)b(1) + b(2)*u);
hold off
