classdef bell_weight < handle
    properties
        P = [0;0;0]
    end
    methods
        function o = bell_weight(P)
            o.P = P;
        end
        
        function w = apply(o, x)
            w = gbellmf(x,o.P);
        end
        function u = subsref(o,x)
            u = o.apply(x.subs{:});
        end
    end
end