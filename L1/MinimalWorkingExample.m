function MinimalWorkingExample()
    addpath('D:\SerialCommunication'); % add a path to the functions
    initSerialControl COM10 % initialise com port
    while(1)
       
        %% obtaining measurements
        measurements1 = readMeasurements(1); % read measurements from 1 to 7
        measurements3 = readMeasurements(3);
        %% processing of the measurements and new control values calculation

        %% sending new values of control signals
        sendControls([ 1,2], ... send for these elements
                     [ 0,0]);  % new corresponding control values
        
         measurement = readMeasurements(1:1)
        %% synchronising with the control process
        waitForNewIteration(); % wait for new batch of measurements to be ready
    end
end