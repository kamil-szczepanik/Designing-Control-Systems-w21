clear;
close all;
S1 = step_response_15([0,0,0,0], [1,0,0,0]);
S2 = step_response_15([0,0,0,0], [0,1,0,0]);
S3 = step_response_15([0,0,0,0], [0,0,1,0]);
S4 = step_response_15([0,0,0,0], [0,0,0,1]);

figure()
fig = stairs(S1(:,1));
writematrix([fig.XData; fig.YData]', 'txts/ad2_u1_y1.txt', "Delimiter","tab");
figure()
fig = stairs(S1(:,2));
writematrix([fig.XData; fig.YData]', 'txts/ad2_u1_y2.txt', "Delimiter","tab");
figure()
fig = stairs(S1(:,3));
writematrix([fig.XData; fig.YData]', 'txts/ad2_u1_y3.txt', "Delimiter","tab");

figure()
fig = stairs(S2(:,1));
writematrix([fig.XData; fig.YData]', 'txts/ad2_u2_y1.txt', "Delimiter","tab");
figure()
fig = stairs(S2(:,2));
writematrix([fig.XData; fig.YData]', 'txts/ad2_u2_y2.txt', "Delimiter","tab");
figure()
fig = stairs(S2(:,3));
writematrix([fig.XData; fig.YData]', 'txts/ad2_u2_y3.txt', "Delimiter","tab");

figure()
fig = stairs(S3(:,1));
writematrix([fig.XData; fig.YData]', 'txts/ad2_u3_y1.txt', "Delimiter","tab");
figure()
fig = stairs(S3(:,2));
writematrix([fig.XData; fig.YData]', 'txts/ad2_u3_y2.txt', "Delimiter","tab");
figure()
fig = stairs(S3(:,3));
writematrix([fig.XData; fig.YData]', 'txts/ad2_u3_y3.txt', "Delimiter","tab");

figure()
fig = stairs(S4(:,1));
writematrix([fig.XData; fig.YData]', 'txts/ad2_u4_y1.txt', "Delimiter","tab");
figure()
fig = stairs(S4(:,2));
writematrix([fig.XData; fig.YData]', 'txts/ad2_u4_y2.txt', "Delimiter","tab");
figure()
fig = stairs(S4(:,3));
writematrix([fig.XData; fig.YData]', 'txts/ad2_u4_y3.txt', "Delimiter","tab");

S1 = S1';
S2 = S2';
S3 = S3';
S4 = S4';
S1 = S1(:);
S2 = S2(:);
S3 = S3(:);
S4 = S4(:);
S = [S1,S2,S3,S4];
S = reshape(S,3,[],4);
S = permute(S,[2,1,3]);
save("data/model","S");