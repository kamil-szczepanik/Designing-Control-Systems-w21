close;
clear;
load("data/DMC_SIM.mat");
load("data/model.mat");

addpath('D:\SerialCommunication'); % add a path to the functions
initSerialControl COM10 % initialise com port
controller =  DMC(Sm(1:301), lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);

y_zad = ones(600,1) * 40;
y_zad(60:end,:) = 45;
y_zad(200:end,:) = 55;
y_zad(400:end,:) = 40;
[~, u,y] = systemSim(controller, @real_obj, y_zad, 1, size(y_zad,1));
err = norm(y_zad-y);
disp(err);

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

    sendControls([1,3], ... send for these elements
                 [50,0]);  % new corresponding control values
    sendNonlinearControls(u);  % new corresponding control values

    waitForNewIteration(); % wait for new batch of measurements to be ready
end