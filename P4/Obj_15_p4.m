classdef Obj_15_p4 < handle
    properties
        U = zeros(4,4);
        Y = zeros(4,3);
    end
    methods
        function y = step(o, u)
            y = NaN(1,3);
            [y(1),y(2),y(3)] = symulacja_obiektu15_p4( ...
                o.U(1,1), o.U(2,1), o.U(3,1), o.U(4,1), ...
                o.U(1,2), o.U(2,2), o.U(3,2), o.U(4,2), ...
                o.U(1,3), o.U(2,3), o.U(3,3), o.U(4,3), ...
                o.U(1,4), o.U(2,4), o.U(3,4), o.U(4,4), ...
                o.Y(1,1), o.Y(2,1), o.Y(3,1), o.Y(4,1), ...
                o.Y(1,2), o.Y(2,2), o.Y(3,2), o.Y(4,2), ...
                o.Y(1,3), o.Y(2,3), o.Y(3,3), o.Y(4,3));
            o.U = [u(:)'; o.U(1:end-1,:)];
            o.Y = [y; o.Y(1:end-1,:)];
        end
        function y = subsref(o,uz)
            y = o.step(uz.subs{:});
        end
    end
end