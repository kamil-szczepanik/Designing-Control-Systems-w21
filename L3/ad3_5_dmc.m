close;
clear;

addpath('D:\SerialCommunication'); % add a path to the functions
initSerialControl COM10 % initialise com port

load("data/DMC_SIM.mat");

y_zad = ones(640,1) * 25;
y_zad(60:end,:) = 45;
y_zad(400:end,:) = 30;
T =1;
dMV_MIN = -100;
dMV_MAX = 100;
controllers = {DMC(Sm, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)};
w1 = trapezoid_weight([-inf,-inf,33,36]);
weights = { @(u,y) 1};
controller = Fuzzy(weights, controllers);
[~, u,y] = systemSimFuzzy(controller, @real_obj, y_zad, 1,  size(y_zad,1));
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