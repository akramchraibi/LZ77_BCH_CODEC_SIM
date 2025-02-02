function S=Codeur_H(X,h,n,k,a)       
h=gf(h,2);
X=gf([0 X zeros(1,n-k)],2);
c=gf([zeros(1,n+1)],2);
C=[c];
for i=1:k-1
    C=[C;c];
end
A=[X(1)];
for i=1:k
    A=[A,C(i,1)];
end
A=[A,X(1)];
for i=2:k+1
    C(1,i)=X(i);
    for j=2:k
        C(j,i)=C(j-1,i-1);
    end
    B=[X(i)];
    for j=1:k
        B=[B C(j,i)];
    end
    B=[B X(i)];
    A=[A;B];
end
for i=k+2:n+1
    C(1,i)=h(2)*C(1,i-1);
    for j=2:k
        C(1,i)=C(1,i)+h(j+1)*C(j,i-1);
    end
    B=[X(i) C(1,i)];
    for j=2:k
        C(j,i)=C(j-1,i-1);
        B=[B C(j,i)];
    end
    B=[B C(1,i)];
    A=[A;B];
end
B=["X(n)"];
for i=k-1:-1:0
    B=[B "c"+i+"(n)"];
end
Tableau_codage_h=[B "a(n)";""+A.x]
if a==1
diag_h(k,h);
end
A=A.x;
a=[];
b="";
for i=2:n+1
    a=[a A(i,end)];
    b=b+A(i,end);
end
"Le code est : "+b
S=b;
end
    

