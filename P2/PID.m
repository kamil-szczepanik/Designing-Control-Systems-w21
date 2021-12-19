classdef PID < handle
    properties
        % Wektor uchyb�w regulacji
        E = [0,0,0]
        
        % Warto�� steruj�ca liczona przez algorytm PID
        MV = 0
        
        % Warto�� steruj�ca po na�o�eniu ogranicze�
        MV_real = 0
        
        % Warto�� minimalna sterowania
        MV_MIN double
        
        % Warto�� maksymalna sterowania
        MV_MAX double
        
        % Warto�� o jak� wyj�ciowa warto�� sterowania
        % jest przesuwana
        Shift = 0
        
        % Warto�� minimalna przyrostu sterowania
        dMV_MIN double
        
        % Warto�� maksymalna przyrostu sterowania
        dMV_MAX double
        
        % Wzmocnienie proporcjonalne
        K double
        
        % Czas wyprzedzenia
        Td double
        
        % Czas zdwojenia
        Ti double
        
        % Czas pr�bkowania
        T double
    end
    methods
        function obj = PID(K, Ti, Td, T, MV_MIN, MV_MAX,...
                           dMV_MIN, dMV_MAX)
            % K - Parametr PID - Wzmocnienie proporcjonalne
            % Ti - Parametr PID - Czas wyprzedzenia
            % Td - Parametr PID - Czas zdwojenia
            % T - Okres pr�bkowania
            % MV_MIN - Warto�� minimalna sterowania
            % MV_MAX - Warto�� maksymalna sterowania
            % dMV_MIN - Warto�� minimalna przyrostu sterowania
            % dMV_MAX - Warto�� maksymalna przyrostu sterowania
            
            % Przypisanie parametr�w do obiektu
            obj.K = K;
            obj.Ti = Ti;
            obj.Td = Td;
            obj.T = T;
            obj.MV_MIN = MV_MIN;
            obj.MV_MAX = MV_MAX;
            obj.dMV_MIN = dMV_MIN;
            obj.dMV_MAX = dMV_MAX;
            
            % AW nie b�dzie poprawnie dzia�a�, je�eli regulator 
            % dla niezerowego uchybu ustali si� na granicy 
            % sterowania. Nawet pomijaj�c AW, jako�� sterowania 
            % i tak by�aby gorsza bez poni�szych warunk�w. 
            % Poni�szy warunek zasadniczo przesuwa ograniczenia 
            % oraz zapisuje to przesuni�cie, by wzi�� je pod 
            % uwag� przy zwracaniu warto�ci steruj�cej. Celem jest
            % by warto�� sterowana r�wna 0, liczona przez 
            % algorytm PID zawsze by�a warto�ci� dopuszczaln�
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
        
        % Metoda zwracaj�ca sterowanie na kolejn� iteracj�
        function MV = step(o, e)
            % e - e(k) - uchyb w aktualnej chwili
            
            % Przesuni�cie historii
            o.E = [o.E(2:3),e];
            
            % Sprawdzenie warunku na anti-windup
            AW = double(~((o.MV > o.MV_MAX) || ...
                        (o.MV < o.MV_MIN)));
            
            % Obliczenie wsp�czynnik�w prawa regulacji
            R = [   o.K*o.Td/o.T
                    o.K*((AW * o.T/(2.0*o.Ti))-(2.0*o.Td/o.T)-1.0)
                    o.K*(1.0+(AW * o.T/(2.0*o.Ti))+o.Td/o.T)
                ];
            
            % Obliczenie przyrostu sterowania
            dMV = o.E*R;
            
            % Obliczenie sterowania
            o.MV = dMV + o.MV;
            
            
            % Ograniczenia nie powinny by� nak�adane na sterowanie
            % u�ywane przez algorytm PID, ze wzgl�du na form� 
            % r�wna� r�nicowych.
            
            % Na�o�enie ogranicze� na przyrosty sterowania
            o.MV_real = min(max(o.MV, o.MV_real + o.dMV_MIN), ...
                            o.MV_real + o.dMV_MAX);
            
            % Na�o�enie ogranicze� na sterowanie
            o.MV_real = min(max(o.MV_MIN,o.MV_real),o.MV_MAX);
            
            % Zwr�cenie sterowania z uwzgl�dnieniem przesuni�cia
            MV = o.MV_real + o.Shift;
        end
        
        % Metoda specjalna, pozwalaj�ca wywo�a� metod� step, 
        % poprzez bezpo�rednie wywo�anie obiektu
        function MV = subsref(o,e)
            MV = o.step(e.subs{:});
        end
    end
end