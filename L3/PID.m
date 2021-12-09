classdef PID < handle
    properties
        E = [0,0,0]
        MV = 0
        MV_real = 0
        MV_MIN double
        MV_MAX double
        Shift = 0
        dMV_MIN double
        dMV_MAX double
        K double
        Td double
        Ti double
        T double
    end
    methods
        function obj = PID(K, Ti, Td, T, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
            %K, Ti, Td - parammetry regulatora PID
            %T - Okres próbkowania
            %MV_MIN, MV_MAX - Wartoœæ minimalna i maksymalna sterowania
            %dMV_MIN, dMV_MAX - Wartoœæ minimalna i maksymalna przyrostu sterowania
            obj.K = K;
            obj.Ti = Ti;
            obj.Td = Td;
            obj.T = T;
            obj.MV_MIN = MV_MIN;
            obj.MV_MAX = MV_MAX;
            obj.dMV_MIN = dMV_MIN;
            obj.dMV_MAX = dMV_MAX;
            % AW nie bêdzie poprawnie dzia³a³, je¿eli regulator dla
            % niezerowego uchybu ustali siê na granicy sterowania.
            % Nawet pomijaj¹c AW, jakoœæ sterowania i tak by³aby gorsza
            % bez poni¿szych warunków.
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
        function MV = step(o, e)
            o.E = [o.E(2:3),e];
            AW = double(~((o.MV > o.MV_MAX) || (o.MV < o.MV_MIN)));
            R = [   o.K*o.Td/o.T
                    o.K*((AW * o.T/(2.0*o.Ti))-(2.0*o.Td/o.T)-1.0)
                    o.K*(1.0+(AW * o.T/(2.0*o.Ti))+o.Td/o.T)
                ];
            dMV = o.E*R;
            o.MV = dMV + o.MV;
            % Ograniczenia nie powinny byæ nak³adane na MV wewnêtrzne
            % PID'a, ze wzglêdu na formê równañ ró¿nicowych.
            o.MV_real = min(max(o.MV, o.MV_real + o.dMV_MIN), o.MV_real + o.dMV_MAX);
            o.MV_real = min(max(o.MV_MIN,o.MV_real),o.MV_MAX);
            MV = o.MV_real + o.Shift;
        end
        function MV = subsref(o,e)
            MV = o.step(e.subs{:});
        end
    end
end