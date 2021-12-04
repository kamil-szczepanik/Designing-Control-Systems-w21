classdef Obj_15Y_p3 < handle
    properties
        U = zeros(1,6);
        Y = zeros(1,2);
    end
    methods
        function y = step(o, u)
            y = symulacja_obiektu15y_p3(o.U(5), ...
                o.U(6),o.Y(1), o.Y(2));
            o.U = [u, o.U(1:end-1)];
            o.Y = [y, o.Y(1:end-1)];
        end
        function y = subsref(o,uz)
            y = o.step(uz.subs{:});
        end
    end
end