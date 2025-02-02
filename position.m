function S=position(l,alpha)
    n=length(l.x);
    n2=length(alpha);
    a=l.x;
    b=flip(alpha);
    S=[];
    for i=1:n
        for j=1:n2
            if a(i)==b(j)
                S=[S j-1];
            end
        end
        if a(i)==0
            S=[S 404];
        end
end
        