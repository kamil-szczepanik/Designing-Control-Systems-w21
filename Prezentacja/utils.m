A=9.7;
Tu=0.0515;
ysp=0.5;
epsilon= 0.2;
bias=0;
delta=0.4;
Ku = 4*delta/(pi*sqrt(A^2-epsilon^2));
fprintf('Ku = %f;\nTu = %f;\n',Ku,Tu);

K_pid=0.6*Ku
Ti_pid=0.8*Tu
Td_pid=0.125*Tu

save("data/PID_params/przekaznik_white_noise", 'K_pid', 'Ti_pid','Td_pid')