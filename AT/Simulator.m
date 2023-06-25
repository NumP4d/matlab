classdef Simulator
    properties (SetAccess = private)
        Ts
        x0
        u0
        y0 
        x
        u
        y
    end
    methods
        function obj = Simulator(x0, u0, y0, Ts)
          obj.x = x0;
          obj.u = u0;
          obj.y = y0;
          obj.Ts = Ts;
        end
        function [obj, y] = Calculate(x, u)
            
        end
        function obj = Train(obj, x, d)
            obj.mu1 = mean(x(d == -1, :));
            obj.sigma1 = std(x(d == -1, :));
            obj.mu2 = mean(x(d == 1, :));
            obj.sigma2 = std(x(d == 1, :));
        end
        function [mu1, sigma1, mu2, sigma2] = GetTrainedParams(obj)
            mu1 = obj.mu1;
            sigma1 = obj.sigma1;
            mu2 = obj.mu2;
            sigma2 = obj.sigma2;
        end
        function [d, perror] = Classify(obj, x)
            p1 = normpdf(x, obj.mu1, obj.sigma1);
            p2 = normpdf(x, obj.mu2, obj.sigma2);
            % Calculate multiplied probablities %
            p1_mul = ones(size(x, 1), 1);
            p2_mul = p1_mul;
            for i = 1:size(x, 2)
                p1_mul = p1_mul .* p1(:, i);
                p2_mul = p2_mul .* p2(:, i);
            end
            d = double(p2_mul > p1_mul);
            d(d == 0) = -1;
            perror = zeros(length(d), 1);
            for i = 1:length(d)
                if (d(i) == 1)  % P2 class
                    perror(i) = p1_mul(i) / (p1_mul(i) + p2_mul(i));
                else            % P1 class
                    perror(i) = p2_mul(i) / (p1_mul(i) + p2_mul(i));
                end
            end
        end
    end
end