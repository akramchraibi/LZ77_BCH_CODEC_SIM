function [Sm,Sv]=Smv(S,t)
    Sm=[];
    Sv=[];
    for i=1:t
        B=[];
        for j=i:t+i-1
            B=[S(j) B];
        end
        Sm=[Sm ; B];
        Sv=[Sv;S(i+t)];
    end