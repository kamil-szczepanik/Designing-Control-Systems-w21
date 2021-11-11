addpath('D:\SerialCommunication'); 
initSerialControl COM10
while(measurements > 26)
    measurements = readMeasurements(1);
    clc;
    disp(measurements);
    sendControls([1,2,3,4, 5, 6], ...
                 [100,0,100,0,0,0]);
    waitForNewIteration(); 
end
sendControls([1,2,3,4, 5, 6], ... 
             [50,0,0,0,25,0]); 