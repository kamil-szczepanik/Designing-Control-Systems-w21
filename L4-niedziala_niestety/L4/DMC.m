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
        KMp(:,:) double
        
        % Macierz K
        K(:,:) double
        
        % Wektor przyrostów sterowania
        dU(:,1) double
        
        % Wartość sterująca
        MV
        
        nu = 1
        N
    end
    methods
        
        % Konstruktor obiektu
        function [obj,K,KMp] = DMC(s, psi, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
            %s - wspołczynniki odpowiedzi skokowej
            %lambda  - współczynnik kary
            %N - Horyzont predykcji
            %Nu - Horyzont sterowania
            % MV_MIN - Wartość minimalna sterowania
            % MV_MAX - Wartość maksymalna sterowania
            % dMV_MIN - Wartość minimalna przyrostu sterowania
            % dMV_MAX - Wartość maksymalna przyrostu sterowania
            
            % Wnioskuje horyzon dynamiki na podstawie długości
            % podanej odpowiedzi skokowej
            D = size(s,1);
            ny = size(s,2);
            obj.nu = size(s,3);
            obj.MV = zeros(obj.nu,1);
            obj.N = N;
            psi = psi(:);
            lambda = lambda(:);
            if size(psi,1) < ny
                psi = repmat(psi,ny,1);
            end
            if size(lambda,1) < obj.nu
                lambda = repmat(lambda,obj.nu,1);
            end
            psi = diag(repmat(psi,N,1));
            lambda = diag(repmat(lambda,Nu,1));
            
            % Wymuszenie, by Nu było mniejsze od N
            Nu = min(Nu,N);
            % Inicjalizacja wektorów
            obj.dU = zeros(obj.nu*(D-1),1);
            
            % Przypisanie pozostałych parametrów do obiektu
            MV_MIN = MV_MIN(:);
            MV_MAX = MV_MAX(:);
            dMV_MIN = dMV_MIN(:);
            dMV_MAX = dMV_MAX(:);
            if size(MV_MIN,1) < obj.nu
                MV_MIN = repmat(MV_MIN,obj.nu,1);
            end
            if size(MV_MAX,1) < obj.nu
                MV_MAX = repmat(MV_MAX,obj.nu,1);
            end
            if size(dMV_MIN,1) < obj.nu
                dMV_MIN = repmat(dMV_MIN,obj.nu,1);
            end
            if size(dMV_MAX,1) < obj.nu
                dMV_MAX = repmat(dMV_MAX,obj.nu,1);
            end
            obj.MV_MIN = MV_MIN;
            obj.MV_MAX = MV_MAX;
            obj.dMV_MIN = dMV_MIN;
            obj.dMV_MAX = dMV_MAX;
            
            % Obliczenie macierzy M
            M = zeros(N*ny,Nu*obj.nu);
            for n = 0:Nu-1
                for m = n:N-1
                    M(m*ny+1:m*ny+ny,n*obj.nu+1:n*obj.nu+obj.nu) = squeeze(s(m-n+1,:,:));
                end
            end        
            
            % Obliczenie macierzy Mp 
            Mp = zeros(N*ny,(D-1)*obj.nu);
            for n = 0:D-2
                for m = 0:N-1
                    Mp(m*ny+1:m*ny+ny,n*obj.nu+1:n*obj.nu+obj.nu) = squeeze(s(min(m+n+2,D),:,:)) - squeeze(s(n+1,:,:));
                end
            end        
            % Obliczenie macierzy K
            % Użyto lsqminnorm ponieważ zwraca on numerycznie 
            % lepsze wyniki niż standardowe ldivide w przypadkach,
            % kiedy lambda jest bardzo mała. W pozostałych
            % przypadkach radzi sobie równie dobrze. 
            obj.K = lsqminnorm(M' * psi * M + lambda,M');
            
            % Usunięcie wierszy macierzy K, które nie będą  
            % wykorzystywane w liczeniu sterowania.
            K = obj.K(1:obj.nu,:);
            KMp = K*Mp;
            for y_i = 1:1:ny
                K(:,y_i) = sum(K(:,y_i:ny:end),2);
            end
            K = K(:,1:ny);
            obj.KMp = KMp;
            obj.K = K;
        end
        
        % Metoda zwracająca sterowanie na kolejną iterację
        function MV = step(o, e)
            %e - e(k) - uchyb w aktualnej chwili
            
            % Policzenie przyrostu sterowania na aktualną iterację 
            % oraz przesunięcie historii;
            o.dU = [ sum(o.K * e(:),2) - o.KMp * o.dU
                        o.dU(1:end-o.nu)];
                    
            % Nałożenie ograniczeń na przyrosty sterowania
            o.dU(1:o.nu) = min(max(o.dU(1:o.nu), o.dMV_MIN), o.dMV_MAX); 
            
            % Nałożenie ograniczenia na maksymalne sterowanie
            o.dU(1:o.nu) = min(o.dU(1:o.nu), o.MV_MAX - o.MV); 
            
            % Nałożenie ograniczenia na minimalne sterowanie
            o.dU(1:o.nu) = max(o.dU(1:o.nu), o.MV_MIN - o.MV); 
            
            % Obliczenie aktualnego sterowania
            o.MV = o.dU(1:o.nu) + o.MV;
            
            MV = o.MV;
        end 
        
        % Metoda specjalna, pozwalająca wywołać metodę step, 
        % poprzez bezpośrednie wywołanie obiektu
        function MV = subsref(o,e)
            MV = o.step(e.subs{:});
        end
    end
end