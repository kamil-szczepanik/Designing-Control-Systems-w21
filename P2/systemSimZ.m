% Symulator uk³adu
function [t, u,y] = systemSimZ(controller, object, y_zad, z_zad, Tp, Tfinal)
    %u = controller(y_zad, y)
    %y = object(u)
    t = (0:Tp:Tfinal-1)';
    u = zeros(size(t,1),1);
    y = u;
    if size(y_zad,1) == 1
        y_zad = ones(size(t,1),1) * y_zad;
    end
    if size(z_zad,1) == 1
        z_zad = ones(size(t,1),1) * z_zad;
    end
 
    y(1) = object(0,0);
    for k = 1:1:size(t,1)-1
        u(k) = controller(y_zad(k) - y(k),z_zad(k));
        y(k+1) = object(u(k),z_zad(k));
%         clc;
%         fprintf("t: %0.2f\ny_zad: %0.2f\nu: %0.2f\ny: %0.2f\nz: %0.2f",t(k),y_zad(k),u(k),y(k),z_zad(k))
    end    
    u(end) = controller(y_zad(end) - y(end),z_zad(end));
end