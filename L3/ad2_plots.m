clear;
close all;
Y = [30.93, 35, 39.12, 43.75, 48.18, 49.25, 50.93]
U = linspace(20,80,7)
figure(1)
scatter(U,Y);
figure(2)
grid on
x = U(1:3)';
y = Y(1:3)';
X = [x.^0, x];
b = (X'*X)\X'*y;
ym = X*b;
disp(b)
hold on
scatter(x, y)
fplot(@(u)b(1) + b(2)*u);
hold off
