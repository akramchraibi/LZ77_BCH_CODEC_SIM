function S=z(g)
    j=1;
    while g(j)==0
        j=j+1;
    end
    S=g(j:end);
end
            