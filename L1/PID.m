classdef PID < handle
    properties
        E = [0,0,0]
        MV = 0
        MV_MIN double
        MV_MAX double
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
        end
        function MV = step(o, e)
            o.E = [o.E(2:3),e];
            AW = double(~((o.MV > o.MV_MAX) || (o.MV < o.MV_MIN)));
            R = [   o.K*o.Td/o.T
                    o.K*((AW * o.T/(2.0*o.Ti))-(2.0*o.Td/o.T)-1.0)
                    o.K*(1.0+(AW * o.T/(2.0*o.Ti))+o.Td/o.T)
                ];
            o.MV = o.E*R + o.MV;
            o.MV = min(max(o.MV_MIN,o.MV),o.MV);
%             o.dU(1) = min(o.dU(1), o.MV_MAX - o.MV); 
%             o.dU(1) = max(o.dU(1), o.MV_MIN - o.MV); 
            MV = o.MV;
        end
        function MV = subsref(o,e)
            MV = o.step(e.subs{:});
        end
    end
end