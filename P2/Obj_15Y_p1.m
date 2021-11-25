classdef Obj_15Y_p1 < handle
    properties
        U = zeros(1,11);
        Y = zeros(1,2);
    end
    methods
        function y = step(o, u)
            y = symulacja_obiektu15Y_p1(o.U(10), ...
                    o.U(11), o.Y(1), o.Y(2));
            o.U = [u, o.U(1:end-1)];
            o.Y = [y, o.Y(1:end-1)];
        end
        function y = subsref(o,u)
            y = o.step(u.subs{:});
        end
    end
end