%%Compute reduct from numerical data, categorical data and their mixtures with fuzzy information entropy. 
%%Please refer to the following papers: 
%%Qinghua Hu, Daren Yu, Zongxia Xie. Information-preserving hybrid data reduction based on fuzzy-rough techniques.
%%Pattern recognition letters. 2006, 27 (5): 414-423.
%%Uploaded by Yuan Zhong on Sep. 27, 2021. E-mail:yuanzhong66@qq.com.
function select_feature=FAR_FIE(data)
%%%input:
% data is data matrix, where rows for samples and columns for attributes. 
% Numerical attributes should be normalized into [0,1] and decision attribute is put in the last column 
% fuzzyneighbor means the fuzzy radius , usually takes value 0.25 in [1]
%%%output
% a reduct--- the set of selected attributes.
[row,column]=size(data);
fuzzyradius=zeros(1,column);  
for j=1:column
    if min(data(:,j))==0&&max(data(:,j))==1
     fuzzyradius(j)=0.25; 
    end
end

%%%%%%%%%%%%%%%%%%%%%%compute the fuzzy relation matrix %%%%%%%%%%%%%%%%%%%
    for i=1:column
        col=i;
        r=[];
        eval(['ssr' num2str(col) '=[];']);
        for j=1:row      
            a=data(j,col);
            x=data(:,col);       
            for m=1:length(x)
                r(j,m)=kersim_fie(a,x(m),fuzzyradius(i));
            end
        end
        eval(['ssr' num2str(col) '=r;']);
    end      
%%%%%%%%%%%%%%%%%%%%%%data reduct based on entropy%%%%%%%%%%%%%%%%%%%%%%%%%
attrinu=column-1;
red=[];
x=0;
base=ones(row);
AllC=1:attrinu;
r=eval(['ssr' num2str(column)]);
for j=attrinu:-1:1
    sig=[];
    for i=1:length(AllC)
       r1=eval(['ssr' num2str(AllC(i))]);
        sig(i)=entropy(min(base,r))-entropy(base)+entropy(min(r1,base))-entropy(min(min(r1,r),base));
    end
    [x1,n1]=max(sig);
    x=[x;x1];
    len=length(x);
    if x(len)>0
        base1=eval(['ssr' num2str(AllC(n1))]);
        base=min(base,base1);
        red=[red;AllC(n1)];
        AllC=setdiff(AllC,AllC(n1));
    else
        break
    end
end
select_feature=red';
