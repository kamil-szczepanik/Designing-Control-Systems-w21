classdef Fuzzy < handle
    properties
        % Lista regulatorów
        controllers = []
        % Lista funkcji przynależności
        weights = []
        % Sygnał sterujący
        u = 0
        % Liczba regulatorów lokalnych
        length = 0
    end
    methods
        
        % Konstruktor obiektu
        function o = Fuzzy(weights, controllers)
            % weights - Lista funkcji przynależności
            % controllers - Lista regulatorów
            
            % Przypisanie parametrów do obiektu
            o.weights = weights;
            o.controllers = controllers;
            % Określenie ilości regulatorów lokalnych
            o.length = min(size(o.weights,1), ...
                           size(o.controllers,1));
        end
        
        % Metoda zwracająca sterowanie na kolejną iterację
        function u = step(o, y_zad, y)
            % y_zad - Wartośc zadana obiektu
            % y - Wyjście obiektu w aktualnej chwili
            
            % Obliczenie uchybu regulacji
            e = y_zad - y;
            
            % Inicjalizacja wektorów wag i sterowań
            w = zeros(o.length,1);
            u = w;
            
            for i = 1:1:o.length
                % Wybranie i-tej funkcji przynależności
                weight = o.weights{i};
                % Obliczenie i-tej wagi
                w(i) = weight(o.u,y);
                % Wybranie i-tego regulatora
                controller = o.controllers{i};
                % Policzenie sterowania i-tego regulatora
                u(i) = controller(e);
            end
            % Normalizacja wag
            w = w/sum(w);
            
            % Proste, ale kiepskie zabezpieczenie, jeżeli 
            % aktualny punkt pracy dalego odbiega od każdej
            % funkcji przynależności. Jednak przy poprawnie 
            % dobranych zakresach nie powinno do tego dojść.
            if(isnan(w))
                w(:) = 0;
                w(end) = 1;
            end
            % Sterowania są wymnożone przez odpowiadające
            % im wagi, a następnie są zsumowane.
            o.u = sum(w .* u);
            
            % Przepisanie sterowania na wyjście
            u = o.u;
        end
        
        % Metoda specjalna, pozwalająca wywołać metodę step,
        % poprzez bezpośrednie wywołanie obiektu
        function u = subsref(o,e)
            u = o.step(e.subs{:});
        end
    end
end