clear
close all
load("data/model","S");
[controller, K, KMp] = DMC(S, 1, 1, 400, 400, 0, 100, -10, 10);
