addpath('D:\SerialCommunication'); % add a path to the functions
initSerialControl COM10 % initialise com port
measurements = NaN(1200,1);
i=0;
while(1)
    i = i + 1;
    measurements(i) = readMeasurements(1); % read measurements from 1 to 7
    disp(measurements(i));
    sendControls([1,3], ... send for these elements
                 [50,0]);  % new corresponding control values
   
   sendNonlinearControls(30);  % new corresponding control values         
             
    waitForNewIteration(); % wait for new batch of measurements to be ready
end
