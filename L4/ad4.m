load('odp_skok_u1_25_75.mat')
y1_1 = y1;
y2_1 = y2;
step_u1 = u1;
load('odp_skok_u2_30_80.mat')
y1_2 = y1;
y2_2 = y2;
step_u2 = u2;

Sp = step_response(y1_1, y2_1, y1_2, y2_2, step_u1, step_u2);