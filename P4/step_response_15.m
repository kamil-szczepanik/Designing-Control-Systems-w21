function S = step_response_15(U_pp, U_zad)
    sim_lenght = 400;
    step_moment = 100;
    Y = zeros(sim_lenght,1);
    U = zeros(sim_lenght,1);
    U(:) = U_pp;
    U(step_moment:end) = U_zad;
    for k=30:sim_lenght
        Y(k) = symulacja_obiektu15y_p3(U(k-5), ...
        U(k-6),Y(k-1), Y(k-2));
    end
    S = Y(step_moment:end);
    S = (S-S(1))/(U_zad-U_pp);
end