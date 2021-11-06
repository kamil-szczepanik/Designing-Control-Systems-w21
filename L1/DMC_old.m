% Regulator DMC
function MV = DMC_old(e, s, lambda, N, Nu, MV_MIN, MV_MAX)
    %e - e(k) - uchyb w aktualnej chwili
    %s - wspo³czynniki odpowiedzi skokowej
    %lambda  - wspó³czynnik kary
    %N - Horyzont predykcji
    %Nu - Horyzont sterowania
    %MV_MIN, MV_MAX - Wartoœæ minimalna i maksymalna sterowania
    s = s(:); %Force s to be a column vector
    D = size(s,1);
    Nu = min(Nu, N); %Nu cannot be bigger than N;
    persistent Mp K dU MV_I
    if isempty(K) %Inicjalizacja
        MV_I = 0;
        dU = zeros(D-1,1);
        M = toeplitz(s(min(1:N, size(s,1))), [s(1), zeros(1,Nu - 1)]);
        Mp = hankel(s(min(2:N+1, size(s,1))), s(min(N + (1:D-1),size(s,1)))) - s(1:end-1)';
        K = (M' * M + diag(zeros(Nu,1) + lambda))\M';
        K = K(1,:); %Nie potrzebujemmy reszty wierszy
    end
    % Obliczenie sterowania
    dU = [K*(e - Mp * dU); dU(1:end-1)];
    if dU(1) + MV_I > MV_MAX
        dU(1) = MV_MAX - MV_I;
    elseif dU(1) + MV_I < MV_MIN
        dU(1) = MV_MIN - MV_I;
    end
    MV_I = dU(1) + MV_I;
    MV = MV_I;%Persistent variable nie mo¿y byæ wyjœciem :(
end