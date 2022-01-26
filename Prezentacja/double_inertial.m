function obj = double_inertial(K,Td,T1,T2,Y0,freq)
    if nargin < 5
        Y0 = 0;
    end
    alfa1 = exp(-1/T1);
    alfa2 = exp(-1/T2);
    a1 = -alfa1 - alfa2;
    a2 = alfa1 * alfa2;
    b1 = (K/(T1-T2))*(T1*(1-alfa1) - T2*(1-alfa2));
    b2 = (K/(T1-T2))*(alfa1 * T2*(1-alfa2) - alfa2 * T1*(1-alfa1));
    b = zeros(Td+2,1);
    b(Td+1) = b1;
    b(Td+2) = b2;
    a = [-a1;-a2];
    obj = Obj(b,a,Y0,freq);    
end