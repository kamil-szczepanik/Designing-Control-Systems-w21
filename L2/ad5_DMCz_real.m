close;
clear;
load("data/model.mat");
load("data/model_z.mat");

addpath('D:\SerialCommunication'); % add a path to the functions
initSerialControl COM10 % initialise com port
lambda = 0.01;
N = 25;
Nu = 1;
MV_MIN = 0;
MV_MAX= 100;
dMV_MIN = -10;
dMV_MAX = 10;
controller =  DMCz(Sm(1:301),Sm_z(1:501), lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX);

y_zad = ones(640,1);
y_zad(:,:) = 25;
y_zad(60:end,:) = 35;
y_zad(400:end,:) = 45;
z_zad = ones(640,1);
rng(7);
z_zad(:,:) = 0;
for l = [60:30:600]
    z_zad(l:l+30,:) = ceil(rand(1)*3);
end
z_zad(630:640,:) = ceil(rand(1)*3);
z_zad = z_zad * 10;
[~, u,y] = systemSimZ(controller, @real_obj, y_zad, z_zad, 1, size(y_zad,1));
err = norm(y_zad-y);
disp(err);

figure(1)
hold on
stairs(y);
stairs(y_zad);
hold off
figure(2)
hold on
stairs(u);
stairs(z_zad);
hold off

function y = real_obj(u,z)
    y = readMeasurements(1); % read measurements from 1 
    sendControlsToG1AndDisturbance(u,z);  % new corresponding control values
    sendControls([1,3,5], ... send for these elements
                 [50,0,u]);  % new corresponding control values
    waitForNewIteration(); % wait for new batch of measurements to be ready
end