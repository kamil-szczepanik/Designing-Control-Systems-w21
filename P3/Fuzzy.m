classdef Fuzzy < handle
    properties
        controllers = []
        weights = []
        u = 0
        length = 0
    end
    methods
        function o = Fuzzy(weights, controllers)
            o.weights = weights(:);
            o.controllers = controllers(:);
            o.length = min(size(o.weights,1),size(o.controllers,1));
        end
        
        function u = step(o, y_zad, y)
            e = y_zad - y;
            w = zeros(o.length,1);
            u = w;
            for i = 1:1:o.length
                w(i) = o.weights(o.u,y);
                controller = o.controllers(i);
                u(i) = controller(e);
            end
            w = w/sum(w);
            o.u = sum(w .* u);
            u = o.u;
        end
        
        function u = subsref(o,e)
            u = o.step(e.subs{:});
        end
    end
end