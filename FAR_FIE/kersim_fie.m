function kersim=kersim_fie(a,x,e)
if abs(a-x)>e
    kersim=0;
else
    if (e==0)
        if (a==x)
            kersim=1;
        else
            kersim=0;
        end
    else
        kersim=1-abs(a-x)/e;    
    end
end