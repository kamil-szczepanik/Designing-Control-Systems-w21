classdef DMC < handle
    properties
        % Wartość minimalna sterowania
        MV_MIN double
        
        % Wartość maksymalna sterowania
        MV_MAX double
        
        % Wartość minimalna przyrostu sterowania
        dMV_MIN double
        
        % Wartość maksymalna przyrostu sterowania
        dMV_MAX double
        
        % Macierz Mp
        Mp(:,:) double
        
        % Macierz K
        K(:,:) double
        
        % Wektor przyrostów sterowania
        dU(:,1) double
        
        % Wartość sterująca
        MV = 0.0
    end
    methods
        
        % Konstruktor obiektu
        function obj = DMC(s, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
            %s - wspołczynniki odpowiedzi skokowej
            %lambda  - współczynnik kary
            %N - Horyzont predykcji
            %Nu - Horyzont sterowania
            % MV_MIN - Wartość minimalna sterowania
            % MV_MAX - Wartość maksymalna sterowania
            % dMV_MIN - Wartość minimalna przyrostu sterowania
            % dMV_MAX - Wartość maksymalna przyrostu sterowania
            
            % Wymusza by s było wektorem kolumnowym
            s = s(:); 
            
            % Wnioskuje horyzon dynamiki na podstawie długości
            % podanej odpowiedzi skokowej
            D = size(s,1);
            
            % Wymuszenie, by Nu było mniejsze od N
            Nu = min(Nu,N);
            
            % Inicjalizacja wektorów
            obj.dU = zeros(D-1,1);
            
            % Przypisanie pozostałych parametrów do obiektu
            obj.MV_MIN = MV_MIN;
            obj.MV_MAX = MV_MAX;
            obj.dMV_MIN = dMV_MIN;
            obj.dMV_MAX = dMV_MAX;
            
            % Obbliczenie macierzy M
            M = toeplitz(s(min(1:N, size(s,1))), ...
                        [s(1), zeros(1,Nu - 1)]);
                    
            % Obbliczenie macierzy Mp 
            obj.Mp = hankel(s(min(2:N+1, size(s,1))), ...
                            s(min(N + (1:D-1),size(s,1))));
            obj.Mp = obj.Mp - s(1:end-1)';
            
            % Obliczenie macierzy K
            % Użyto lsqminnorm ponieważ zwraca on numerycznie 
            % lepsze wyniki niż standardowe ldivide w przypadkach,
            % kiedy lambda jest bardzo mała. W pozostałych
            % przypadkach radzi sobie równie dobrze. 
            obj.K = lsqminnorm(M' * M + ...
                               diag(zeros(Nu,1) + lambda),M');
            
            % Usunięcie wierszy macierzy K, które nie będą  
            % wykorzystywane w liczeniu sterowania.
            obj.K = obj.K(1,:);
        end
        
        % Metoda zwracająca sterowanie na kolejną iterację
        function MV = step(o, e)
            %e - e(k) - uchyb w aktualnej chwili
            
            % Policzenie przyrostu sterowania na aktualną iterację 
            % oraz przesunięcie historii
            o.dU = [ o.K*(e - o.Mp * o.dU)
                        o.dU(1:end-1)];
                    
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