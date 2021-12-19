classdef PID < handle
    properties
        % Wektor uchybów regulacji
        E = [0,0,0]
        
        % Wartoœæ steruj¹ca liczona przez algorytm PID
        MV = 0
        
        % Wartoœæ steruj¹ca po na³o¿eniu ograniczeñ
        MV_real = 0
        
        % Wartoœæ minimalna sterowania
        MV_MIN double
        
        % Wartoœæ maksymalna sterowania
        MV_MAX double
        
        % Wartoœæ o jak¹ wyjœciowa wartoœæ sterowania
        % jest przesuwana
        Shift = 0
        
        % Wartoœæ minimalna przyrostu sterowania
        dMV_MIN double
        
        % Wartoœæ maksymalna przyrostu sterowania
        dMV_MAX double
        
        % Wzmocnienie proporcjonalne
        K double
        
        % Czas wyprzedzenia
        Td double
        
        % Czas zdwojenia
        Ti double
        
        % Czas próbkowania
        T double
    end
    methods
        function obj = PID(K, Ti, Td, T, MV_MIN, MV_MAX,...
                           dMV_MIN, dMV_MAX)
            % K - Parametr PID - Wzmocnienie proporcjonalne
            % Ti - Parametr PID - Czas wyprzedzenia
            % Td - Parametr PID - Czas zdwojenia
            % T - Okres próbkowania
            % MV_MIN - Wartoœæ minimalna sterowania
            % MV_MAX - Wartoœæ maksymalna sterowania
            % dMV_MIN - Wartoœæ minimalna przyrostu sterowania
            % dMV_MAX - Wartoœæ maksymalna przyrostu sterowania
            
            % Przypisanie parametrów do obiektu
            obj.K = K;
            obj.Ti = Ti;
            obj.Td = Td;
            obj.T = T;
            obj.MV_MIN = MV_MIN;
            obj.MV_MAX = MV_MAX;
            obj.dMV_MIN = dMV_MIN;
            obj.dMV_MAX = dMV_MAX;
            
            % AW nie bêdzie poprawnie dzia³a³, je¿eli regulator 
            % dla niezerowego uchybu ustali siê na granicy 
            % sterowania. Nawet pomijaj¹c AW, jakoœæ sterowania 
            % i tak by³aby gorsza bez poni¿szych warunków. 
            % Poni¿szy warunek zasadniczo przesuwa ograniczenia 
            % oraz zapisuje to przesuniêcie, by wzi¹æ je pod 
            % uwagê przy zwracaniu wartoœci steruj¹cej. Celem jest
            % by wartoœæ sterowana równa 0, liczona przez 
            % algorytm PID zawsze by³a wartoœci¹ dopuszczaln¹
            if(MV_MIN > 0)
                obj.Shift = MV_MIN;
                obj.MV_MIN = 0;
                obj.MV_MAX = MV_MAX - MV_MIN;
            elseif(MV_MAX < 0)
                obj.Shift = MV_MAX;
                obj.MV_MIN = MV_MIN - MV_MAX;
                obj.MV_MAX = 0;
            end
        end
        
        % Metoda zwracaj¹ca sterowanie na kolejn¹ iteracjê
        function MV = step(o, e)
            % e - e(k) - uchyb w aktualnej chwili
            
            % Przesuniêcie historii
            o.E = [o.E(2:3),e];
            
            % Sprawdzenie warunku na anti-windup
            AW = double(~((o.MV > o.MV_MAX) || ...
                        (o.MV < o.MV_MIN)));
            
            % Obliczenie wspó³czynników prawa regulacji
            R = [   o.K*o.Td/o.T
                    o.K*((AW * o.T/(2.0*o.Ti))-(2.0*o.Td/o.T)-1.0)
                    o.K*(1.0+(AW * o.T/(2.0*o.Ti))+o.Td/o.T)
                ];
            
            % Obliczenie przyrostu sterowania
            dMV = o.E*R;
            
            % Obliczenie sterowania
            o.MV = dMV + o.MV;
            
            
            % Ograniczenia nie powinny byæ nak³adane na sterowanie
            % u¿ywane przez algorytm PID, ze wzglêdu na formê 
            % równañ ró¿nicowych.
            
            % Na³o¿enie ograniczeñ na przyrosty sterowania
            o.MV_real = min(max(o.MV, o.MV_real + o.dMV_MIN), ...
                            o.MV_real + o.dMV_MAX);
            
            % Na³o¿enie ograniczeñ na sterowanie
            o.MV_real = min(max(o.MV_MIN,o.MV_real),o.MV_MAX);
            
            % Zwrócenie sterowania z uwzglêdnieniem przesuniêcia
            MV = o.MV_real + o.Shift;
        end
        
        % Metoda specjalna, pozwalaj¹ca wywo³aæ metodê step, 
        % poprzez bezpoœrednie wywo³anie obiektu
        function MV = subsref(o,e)
            MV = o.step(e.subs{:});
        end
    end
end