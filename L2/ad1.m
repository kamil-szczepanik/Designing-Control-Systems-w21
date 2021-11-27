addpath('D:\SerialCommunication'); % add a path to the functions
initSerialControl COM10 % initialise com port
while(1)
    measurements = readMeasurements(1); % read measurements from 1 to 7
    clc;
    disp(measurements);

    sendControls([1,3], ... send for these elements
                 [0,0]);  % new corresponding control values
    sendControlsToG1AndDisturbance(0,0);  % new corresponding control values

    waitForNewIteration(); % wait for new batch of measurements to be ready
end