function [x02] = CopyInput(Params, x01)
    Ts     = Params(1);
    l1     = Params(2);
    l2     = Params(3);
    v_vech = Params(4);  % in km/h
    
    x02    = zeros(size(x01));

    v_vech = v_vech * 1000 / 3600; % convert to m/s
    
    delay  = round(((l1 + l2) / v_vech)  / Ts);
    for i = 1:length(x01)
        k = i + delay;
        if (k < length(x01))
            x02(k) = x01(i);
        end
    end
end