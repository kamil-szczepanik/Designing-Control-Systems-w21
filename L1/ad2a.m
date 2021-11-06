%4,5 - Grzałki
addpath('D:\SerialCommunication'); % add a path to the functions
initSerialControl COM10 % initialise com port
measurements = NaN(1200,1);
i=0;
while(1)
    i = i + 1;
    %% obtaining measurements
    measurements(i) = readMeasurements(1); % read measurements from 1 to 7
    disp(measurements(i));
    %% processing of the measurements and new control values calculation

    %% sending new values of control signals
    sendControls([1,2,3,4, 5, 6], ... send for these elements
                 [50,0,0,0,100,0]);  % new corresponding control values

    %% synchronising with the control process
    waitForNewIteration(); % wait for new batch of measurements to be ready
end