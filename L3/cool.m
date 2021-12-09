addpath('D:\SerialCommunication'); 
initSerialControl COM10
measurements = 300;
while(measurements > 26)
    measurements = readMeasurements(1);
    clc;
    disp(measurements);
    sendControls([1,2,3,4, 5, 6], ...
                 [100,0,100,0,0,0]);
    waitForNewIteration(); 
end
sendControls([1,3], ... 
             [50,0]); 
