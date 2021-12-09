classdef fuzzy_PID < handle
    properties
        E = [0,0,0]
        MV = 0
        K vector
        Td vector
        Ti vector
        T double
        MV_MIN double
        MV_MAX double
        dMV_MIN double
        dMV_MAX double
        reg_num int
        MFparams matrix
    end
    methods
function obj = fuzzy_PID(K, Ti, Td, T, MFparams)
            %K, Ti, Td - parammetry regulatora PID
            %T - Okres próbkowania
            %MV_MIN, MV_MAX - Wartość minimalna i maksymalna sterowania
            %dMV_MIN, dMV_MAX - Wartość minimalna i maksymalna przyrostu sterowania
            %MFparams - macierz z parametrami funkcji przynaleznosci trapmf
            obj.K = K;
            obj.Ti = Ti;
            obj.Td = Td;
            obj.T = T;
            obj.MV_MIN = MV_MIN;
            obj.MV_MAX = MV_MAX;
            obj.dMV_MIN = dMV_MIN;
            obj.dMV_MAX = dMV_MAX;
            obj.reg_num = length(obj.K);
            obj.MFparams = MFparams;

        end
        
        function MV = step(o, e)
            U = zeros(1, o.reg_num);
            R = zeros(1, o.reg_num);
            
            o.E = [o.E(2:3),e];
            o.MV; %poprzednie sterowanie
            
            for i=1:o.reg_num
                R(i) = PID(o.K(i),o.Ti(i),o.Td(i), o.T, o.MV_MIN, o.MV_MAX, o.dMV_MIN, o.dMV_MAX);
                controller = R(i);
                U(i) = controller(e);
            end
            
            % TODO:
            % trzeba tutaj obliczyc koncowe u wyznaczone z u lokalnych
            % regulatorow i funkcji przynaleznosci
%             MV = sum(trapmf(U,MFparams)
%             
            
        end
        function MV = subsref(o,e)
            MV = o.step(e.subs{:});
        end
    end
end