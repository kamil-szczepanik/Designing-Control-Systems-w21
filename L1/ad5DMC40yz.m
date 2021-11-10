close;
clear;
load("PID_SIM.mat");
load("model.mat");

addpath('D:\SerialCommunication'); % add a path to the functions
initSerialControl COM10 % initialise com port

MV_MIN = 0;
MV_MAX = 100;
dMV_MIN = -10;
dMV_MAX = +10;
T = 1;
lambda = 0.01;
N = 25;
Nu = 1;
controller =  DMC(Sm(1:301), lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);
y_zad = ones(640,1);
y_zad(:,:) = 25;
y_zad(60:end,:) = 50;
y_zad(400:end,:) = 30;
[~, u,y] = systemSim(controller, @real_obj, y_zad, 1, size(y_zad,1));

err = norm(y_zad-y)
figure(1)
hold on
stairs(y);
stairs(y_zad);
hold off
figure(2)
stairs(u);

function y = real_obj(u)
    y = readMeasurements(1); % read measurements from 1 to 7
    %measurements3 = readMeasurements(3);

    sendControls([1, 5], ... send for these elements
                 [50, u]);  % new corresponding control values

    waitForNewIteration(); % wait for new batch of measurements to be ready
end