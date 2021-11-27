classdef Obj_15Y_p2 < handle
    properties
        U = zeros(1,7);
        Z = zeros(1,4);
        Y = zeros(1,2);
    end
    methods
        function y = step(o, u, z)
            y = symulacja_obiektu15y_p2(o.U(6), ...
                    o.U(7), o.Z(3), o.Z(4), o.Y(1), o.Y(2));
            o.U = [u, o.U(1:end-1)];
            o.Z = [z, o.Z(1:end-1)];
            o.Y = [y, o.Y(1:end-1)];
        end
        function y = subsref(o,uz)
            y = o.step(uz.subs{:});
        end
    end
end