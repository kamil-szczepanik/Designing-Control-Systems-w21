classdef DMCz < handle
    properties
        MV_MIN double
        MV_MAX double
        dMV_MIN double
        dMV_MAX double
        Mp(:,:) double
        Mp_z(:,:) double
        K(:,:) double
        dU(:,1) double
        Z(:,1) double
        MV = 0.0
    end
    methods
        function obj = DMCz(s, s_z, lambda, N, Nu, MV_MIN, MV_MAX, dMV_MIN, dMV_MAX)
            %s - wspołczynniki odpowiedzi skokowej
            %lambda  - współczynnik kary
            %N - Horyzont predykcji
            %Nu - Horyzont sterowania
            %MV_MIN, MV_MAX - Wartość minimalna i maksymalna sterowania
            %dMV_MIN, dMV_MAX - Wartość minimalna i maksymalna przyrostu sterowania
            s = s(:); %Force s to be a column vector
            s_z = s_z(:); %Force s to be a column vector
            D = size(s,1);
            D_z = size(s_z,1);
            Nu = min(Nu,N); %Nu cannot be bigger than N;
            
            obj.dU = zeros(D-1,1);
            obj.Z = zeros(D_z-1,1);
            M = toeplitz(s(min(1:N, size(s,1))), [s(1), zeros(1,Nu - 1)]);
            obj.Mp = hankel(s(min(2:N+1, size(s,1))), s(min(N + (1:D-1),size(s,1)))) - s(1:end-1)';
            obj.Mp_z = hankel(s_z(min(1:N, size(s_z,1))), s_z(min(N-1 + (1:D_z-1),size(s_z,1)))) - [0;s_z(1:end-2)]';
            obj.K = lsqminnorm(M' * M + diag(zeros(Nu,1) + lambda),M');
            obj.K = obj.K(1,:); %Nie potrzebujemmy reszty wierszy
            obj.MV_MIN = MV_MIN;
            obj.MV_MAX = MV_MAX;
            obj.dMV_MIN = dMV_MIN;
            obj.dMV_MAX = dMV_MAX;
        end
        function MV = step(o, e, z)
            %e - e(k) - uchyb w aktualnej chwili
            dZ = [z;o.Z(1:end-1)] - o.Z;
            o.dU = [ o.K*(e - o.Mp * o.dU - o.Mp_z * dZ)
                        o.dU(1:end-1)];
            o.Z = [ z;o.Z(1:end-1)];
                    
            o.dU(1) = min(max(o.dU(1), o.dMV_MIN), o.dMV_MAX); 
            o.dU(1) = min(o.dU(1), o.MV_MAX - o.MV); 
            o.dU(1) = max(o.dU(1), o.MV_MIN - o.MV); 
            
            o.MV = o.dU(1) + o.MV;
            MV = o.MV;
        end 
        function MV = subsref(o,e)
            MV = o.step(e.subs{:});
        end
    end
end