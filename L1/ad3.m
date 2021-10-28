load("u75.mat");
S = measurements;

deltau = 75 - 25;

S = (S-S(1))/deltau;

stairs(S)