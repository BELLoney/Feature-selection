function kersim=dm2010_kersim(a,x,e)
if e==1
    kersim=1-abs(a-x);
else
    if (a==x)
        kersim=1;
    else
        kersim=0;
    end
end