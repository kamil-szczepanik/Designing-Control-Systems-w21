classdef DMCz < handle
    properties
        % Wartość minimalna sterowania
        MV_MIN double
        
        % Wartość maksymalna sterowania
        MV_MAX double
        
        % Wartość minimalna przyrostu sterowania
        dMV_MIN double
        
        % Wartość maksymalna przyrostu sterowania
        dMV_MAX double
        
        % Macierz Mp dla sterowania
        Mp(:,:) double
        
        % Macierz Mp dla zakłócenia
        Mp_z(:,:) double
        
        % Macierz K
        K(:,:) double
        
        % Wektor przyrostów sterowania
        dU(:,1) double
        
        % Wektor wartości zakłóceń
        Z(:,1) double
        
        % Wartość sterująca
        MV = 0.0
    end
    methods
        
        % Konstruktor obiektu
        function o = DMCz(s, s_z, lambda, N, Nu, MV_MIN, ...
                          MV_MAX, dMV_MIN, dMV_MAX)
            % s - wspołczynniki odpowiedzi skokowej sterowania 
            % s_z - wspołczynniki odpowiedzi skokowej zakłócenia
            % lambda  - współczynnik kary
            % N - Horyzont predykcji
            % Nu - Horyzont sterowania
            % MV_MIN - Wartość minimalna sterowania
            % MV_MAX - Wartość maksymalna sterowania
            % dMV_MIN - Wartość minimalna przyrostu sterowania
            % dMV_MAX - Wartość maksymalna przyrostu sterowania
            
            % Wymuś by s oraz s_z to były wektory kolumnowe
            s = s(:); 
            s_z = s_z(:); 
            
            % Wnioskuje horyzon dynamiki (dla sterowania 
            % i zakłócenia) na podstawie długości podanej 
            % odpowiedzi skokowej
            D = size(s,1);
            D_z = size(s_z,1);
            
            % Wymuszenie, by Nu było mniejsze od N
            Nu = min(Nu,N); 
            
            % Inicjalizacja wektorów
            o.dU = zeros(D-1,1);
            o.Z = zeros(D_z-1,1);
            
            % Przypisanie pozostałych parametrów do obiektu
            o.MV_MIN = MV_MIN;
            o.MV_MAX = MV_MAX;
            o.dMV_MIN = dMV_MIN;
            o.dMV_MAX = dMV_MAX;
            
            % Obbliczenie macierzy M
            M = toeplitz(s(min(1:N, size(s,1))), ...
                        [s(1), zeros(1,Nu - 1)]);
            
            % Obbliczenie macierzy Mp dla sterowania
            o.Mp = hankel(s(min(2:N+1, size(s,1))), ...
                          s(min(N + (1:D-1),size(s,1))));
            o.Mp = o.Mp - s(1:end-1)';
            
            % Obbliczenie macierzy Mp dla zakłócenia
            o.Mp_z = hankel(s_z(min(1:N, size(s_z,1))), ...
                            s_z(min(N-1 + (1:D_z-1), ... 
                                    size(s_z,1))));
            o.Mp_z = o.Mp_z - [0;s_z(1:end-2)]';
            
            % Obliczenie macierzy K
            % Użyto lsqminnorm ponieważ zwraca on numerycznie 
            % lepsze wyniki niż standardowe ldivide w przypadkach,
            % kiedy lambda jest bardzo mała. W pozostałych
            % przypadkach radzi sobie równie dobrze. 
            o.K = lsqminnorm(M' * M + ...
                            diag(zeros(Nu,1) + lambda),M');
            
            % Usunięcie wierszy macierzy K, które nie będą  
            % wykorzystywane w liczeniu sterowania.
            o.K = o.K(1,:);
        end
        
        % Metoda zwracająca sterowanie na kolejną iterację
        function MV = step(o, e, z)
            % e - e(k) - uchyb w aktualnej chwili
            % z - z(k) - zakłócenie w aktualnej chwili
            
            % Policzenie przyrostu zakłócenia
            dZ = [z;o.Z(1:end-1)] - o.Z;
            
            % Policzenie przyrostu sterowania na aktualną iterację 
            % oraz przesunięcie historii
            o.dU = [ o.K*(e - o.Mp * o.dU - o.Mp_z * dZ)
                        o.dU(1:end-1)];
                    
            % Przesunięcie historii zakłócenia
            o.Z = [ z;o.Z(1:end-1)];
            
            % Nałożenie ograniczeń na przyrosty sterowania
            o.dU(1) = min(max(o.dU(1), o.dMV_MIN), o.dMV_MAX); 
            
            % Nałożenie ograniczenia na maksymalne sterowanie
            o.dU(1) = min(o.dU(1), o.MV_MAX - o.MV); 
            
            % Nałożenie ograniczenia na minimalne sterowanie
            o.dU(1) = max(o.dU(1), o.MV_MIN - o.MV); 
            
            % Obliczenie aktualnego sterowania
            o.MV = o.dU(1) + o.MV;
            
            MV = o.MV;
        end 
        
        % Metoda specjalna, pozwalająca wywołać metodę step, 
        % poprzez bezpośrednie wywołanie obiektu
        function MV = subsref(o,e)
            MV = o.step(e.subs{:});
        end
    end
end