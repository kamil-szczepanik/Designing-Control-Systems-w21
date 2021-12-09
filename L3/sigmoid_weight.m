classdef sigmoid_weight < handle
    properties
        a = [0,0]
        c = [0,0]
        double_sided = 0
    end
    methods
        function o = sigmoid_weight(a, c)
            o.a = a(:);
            o.c = c(:);
            o.double_sided = min(size(o.a,1),size(o.c,1)) ~= 1;
        end
        
        function w = apply(o, x)
            sigmoid = @(x) 1 / (1 + exp(-x));
            w = sigmoid(o.a(1)*(x-o.c(1)));
            if o.double_sided
                w = w - sigmoid(o.a(2)*(x-o.c(2)));
            end
        end
        function u = subsref(o,x)
            u = o.apply(x.subs{:});
        end
    end
end