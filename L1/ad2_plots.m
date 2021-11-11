load("u25.mat");
load("u50.mat");
load("u75.mat");
load("u100.mat");

figure(1)
plot([u50,u75,u100]);

grid on
x = [25,50,75, 100]';
y = [u25,u50(i50), u75(i75), u100(i100)]';
X = [x.^0, x];
b = (X'*X)\X'*y;
ym = X*b;

figure(2)
hold on
scatter([25,50,75, 100], [29.31,u50(i50), u75(i75), u100(i100)])
fplot(@(u)20.97 + 0.3322*u);
hold off
