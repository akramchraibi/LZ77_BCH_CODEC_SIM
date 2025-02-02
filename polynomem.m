%polynome minimale d'une alpha
function S=polynomem(a,n,p)%a=alpha,n=m=GF(2^m),p=polynome primitif
    alpha=gf(a,n,p);
    S=minpol(alpha);