classdef Obj < handle
    properties
        a double
        b double
        U(1,:) double
        Y(1,:) double
        c double
        counter double
        sin_linspace(1,:) double
        freq double
    end
    methods
        function obj = Obj(a,b,c, freq)
            %y(k) = a(1) * u(k-1)+ a(2) * u(k-2) +  ... + b(1) * y(k-1)+ b(2) * y(k-2)+ ...
            obj.a = a(:);
            obj.b = b(:);
            obj.c = c(:); %Shift by working point
            obj.U = zeros(1,size(obj.a,1));
            obj.Y = zeros(1,size(obj.b,1)) * obj.c;
            obj.counter = 1;
            obj.freq = freq;
            obj.sin_linspace = linspace(-pi,pi,freq);
            
        end
        function y = step(o, u)
            if o.freq >= 0
                u = u + 0.1*sin(o.sin_linspace(mod(o.counter,o.freq)+1));
            end
            
            o.counter = o.counter + 1;
            y = o.U*o.a + o.Y*o.b;
            o.U = [u, o.U(1:end-1)];
            o.Y = [y, o.Y(1:end-1)];
            y = y + o.c;
%             if o.freq >= 0
%                 y = 0.1*sin(o.sin_linspace(mod(o.counter,o.freq)+1)); % uncoment to
% %             test noise
%             end
            
        end
        function y = subsref(o,u)
            y = o.step(u.subs{:});
        end
    end
end