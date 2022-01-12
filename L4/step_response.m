function Sp = step_response(y1_1, y2_1, y1_2, y2_2, step_u1, step_u2)
    D = min(size(y1_1,1), size(y1_2,1));
    for i=1:D
        if step_u1(i) ~= step_u1(1)
            step_moment_u1 = i;
            break
        end
    end
    for i=1:D
        if step_u2(i) ~= step_u2(1)
            step_moment_u2 = i;
            break
        end
    end
    delta_u1 = step_u1(end) - step_u1(1);
    delta_u2 = step_u2(end) - step_u2(1);

    Sp_11 = y1_1(step_moment_u1:end);
    Sp_21 = y2_1(step_moment_u1:end);
    Sp_12 = y1_2(step_moment_u2:end);
    Sp_22 = y2_2(step_moment_u2:end);

    D = min(size(Sp_11,1), size(Sp_12,1));
    Sp_11 = Sp_11(1:D);
    Sp_21 = Sp_21(1:D);
    Sp_12 = Sp_12(1:D);
    Sp_22 = Sp_22(1:D);

    Sp_11 = (Sp_11 - Sp_11(1))/(delta_u1);
    Sp_21 = (Sp_21 - Sp_21(1))/(delta_u1);
    Sp_12 = (Sp_12 - Sp_12(1))/(delta_u2);
    Sp_22 = (Sp_22 - Sp_22(1))/(delta_u2);
    
    figure(1)
    subplot(2,2,1)
    plot(Sp_11)
    legend('Sp_11')
    subplot(2,2,2)
    plot(Sp_21)
    legend('Sp_21')
    subplot(2,2,3)
    plot(Sp_12)
    legend('Sp_12')
    subplot(2,2,4)
    plot(Sp_22)
    legend('Sp_22')

    Sp = [ Sp_11 Sp_12 ; Sp_21 Sp_22 ] ;
end