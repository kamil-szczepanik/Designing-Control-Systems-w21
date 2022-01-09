% Symulator uk³adu
function [t, u1, u2, u3, u4, y1, y2, y3] = systemSim(controller, object, Y_ZAD, Tp, Tfinal)
    %u = controller(y_zad, y)
    %y = object(u)
    t = (0:Tp:Tfinal-1)';
    u1 = zeros(size(t,1),1);
    u2 = zeros(size(t,1),1);
    u3 = zeros(size(t,1),1);
    u4 = zeros(size(t,1),1);
    y1 = u1;
    y2 = u1;
    y3 = u1;
    U = zeros(size(t,1),4);
    Y = zeros(size(t,1),3);
    
%     for i = 1:1:size(Y_ZAD(1,:),2)
%         if size(Y_ZAD(i,:),1) == 1
%             Y_ZAD(i, :) = ones(size(t,1),1) * Y_ZAD(i,:);
%         end
%     end
    

    y_zad1 = Y_ZAD(:,1);
    y_zad2 = Y_ZAD(:,2);
    y_zad3 = Y_ZAD(:,3);

    y1(1) = 0;
    y2(1) = 0;
    y3(1) = 0;
    

    for k = 1:1:size(t,1)-1
        u1(k) = controller(y_zad1(k) - y1(k));
        u2(k) = controller(y_zad2(k) - y2(k));
        u3(k) = controller(y_zad3(k) - y3(k));
        u4(k) = 0;
        
        U(k,:) = [u1(k) u2(k) u3(k) u4(k)];
        Y(k+1,:) = object(U(k,:));
        y1(k+1) = Y(k+1,1);
        y2(k+1) = Y(k+1,2);
        y3(k+1)= Y(k+1,3);

%         Y(k) = [y1(k), y2(k), y3(k)];
%         clc;
%         fprintf("t: %0.2f\ny_zad: %0.2f\nu: %0.2f\ny: %0.2f\nz: %0.2f",t(k),y_zad(k),u(k),y(k),z_zad(k))
    end    
    u1(end) = controller(y_zad1(end) - y1(end));
    u2(end) = controller(y_zad2(end) - y2(end));
    u3(end) = controller(y_zad3(end) - y3(end));
    u4(end) = 0;
end