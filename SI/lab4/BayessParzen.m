classdef BayessParzen
    properties (SetAccess = private)
        x1
        x2
        bw
    end
    methods
        function obj = BayessParzen(obj)
        end
        function obj = Train(obj, x, d, bw)
            obj.x1 = x(d == -1, :);
            obj.x2 = x(d == 1, :);
            obj.bw = bw;
        end
        function [d, perror] = Classify(obj, x)
            p1 = ones(size(x, 1), 1);
            p2 = ones(size(x, 1), 1);
            for i = 1:2:(size(x, 2)-1)
                if (isempty(obj.bw))
                    p1 = p1 .* ksdensity(obj.x1(:, i:(i+1)), x(:, i:(i+1)));
                    p2 = p2 .* ksdensity(obj.x2(:, i:(i+1)), x(:, i:(i+1)));
                else
                    p1 = p1 .* ksdensity(obj.x1(:, i:(i+1)), x(:, i:(i+1)), 'Bandwidth', obj.bw);
                    p2 = p2 .* ksdensity(obj.x2(:, i:(i+1)), x(:, i:(i+1)), 'Bandwidth', obj.bw);
                end
            end
            if (i ~= (size(x, 2)-1))
                disp(i);
                if (isempty(obj.bw))
                    p1 = p1 .* ksdensity(obj.x1(:, end), x(:, end));
                    p2 = p2 .* ksdensity(obj.x2(:, end), x(:, end));
                else
                    p1 = p1 .* ksdensity(obj.x1(:, end), x(:, end), 'Bandwidth', obj.bw);
                    p2 = p2 .* ksdensity(obj.x2(:, end), x(:, end), 'Bandwidth', obj.bw);
                end
            end
            d = double(p2 > p1);
            d(d == 0) = -1;
            perror = zeros(length(d), 1);
            for i = 1:length(d)
                if (d(i) == 1)  % P2 class
                    perror(i) = p1(i) / (p1(i) + p2(i));
                else            % P1 class
                    perror(i) = p2(i) / (p1(i) + p2(i));
                end
            end
        end
    end
end