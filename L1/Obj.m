classdef Obj < handle
    properties
        a double
        b double
        U(1,:) double
        Y(1,:) double
        c double
    end
    methods
        function obj = Obj(a,b,c)
            %y(k) = a(1) * u(k-1)+ a(2) * u(k-2) +  ... + b(1) * y(k-1)+ b(2) * y(k-2)+ ...
            obj.a = a(:);
            obj.b = b(:);
            obj.c = c(:);
            obj.U = zeros(1,size(obj.a,1));
            obj.Y = zeros(1,size(obj.b,1)) * obj.c;
        end
        function y = step(o, u)
            y = o.U*o.a + o.Y*o.b;
            o.U = [u, o.U(1:end-1)];
            o.Y = [y, o.Y(1:end-1)];
            y = y + o.c;
        end
        function y = subsref(o,u)
            y = o.step(u.subs{:});
        end
    end
end