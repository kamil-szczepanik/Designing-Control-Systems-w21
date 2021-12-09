close;
clear;

addpath('D:\SerialCommunication'); % add a path to the functions
initSerialControl COM10 % initialise com port

load("data/ad4_PID_30.mat");
K1 = Kg;
Ti1 = Ti;
Td1 = Td_pid;
load("data/ad4_PID_40.mat");
K2 = Kg;
Ti2 = Ti;
Td2 = Td_pid;
load("data/ad4_PID_45.mat");
K3 = Kg;
Ti3 = Ti;
Td3 = Td_pid;
y_zad = ones(640,1) * 25;
y_zad(60:end,:) = 45;
y_zad(400:end,:) = 30;
T =1;
MV_MIN = 0;
MV_MAX = 100;
dMV_MIN = -100;
dMV_MAX = 100;
controllers = {PID(K1, Ti1, Td1, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               PID(K2, Ti2, Td2, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
               PID(K2, Ti3, Td3, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
              };
w1 = trapezoid_weight([-inf,-inf,33,36]);
w2 = trapezoid_weight([33,36,43,47]);
w3 = trapezoid_weight([43,47,inf,inf]);
weights = { @(u,y) w1(y)
            @(u,y) w2(y)
            @(u,y) w2(y)
          };
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