classdef trapezoid_weight < handle
    properties
        P = [0;0;0;0]
    end
    methods
        function o = trapezoid_weight(P)
            o.P = P;
        end
        
        function w = apply(o, x)
            w = trapmf(x,o.P);
        end
        function u = subsref(o,x)
            u = o.apply(x.subs{:});
        end
    end
end