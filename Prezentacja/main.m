close all;
clear;
clc;
space = 600;
f=10;
a = space/f;
x = linspace(-pi,pi,a);
y = zeros(1,600);
for i = 1:space
    y(i) = sin(x(mod(i,a)+1));
end

plot(y)

load("data/model.mat");
load("data/PID_SIM.mat");
obj = double_inertial(K,Td,T1,T2,20.9700);
obj(0.2)