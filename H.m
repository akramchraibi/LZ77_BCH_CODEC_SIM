function S=H(alpha,t)
    S=[];
    for i=2*t:-1:1
        S=[alpha.^i S];
    end
end