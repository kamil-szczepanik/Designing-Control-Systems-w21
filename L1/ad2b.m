load("u50.mat");
i50 = i;
u50 = measurements;
load("u75.mat");
i75 = i;
u75 = measurements;
load("u100.mat");
i100 = i;
u100 = measurements;
plot([u50,u75,u100]);
grid on
x = [25,50,75, 100]';
y = [29.31,u50(i50), u75(i75), u100(i100)]';
X = [x.^0, x];
b = (X'*X)\X'*y;
ym = X*b;
scatter([25,50,75, 100], [29.31,u50(i50), u75(i75), u100(i100)])
hold on
fplot(@(u)20.97 + 0.3322*u);
hold off
