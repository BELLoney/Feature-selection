%%Compute reduct from numerical data, categorical data and their mixtures by using fuzzy discernibility matrix. 
%%Please refer to the following papers: 
%%Degang C, Suyun Z. Local reduction of decision system with fuzzy rough sets[J].
%%Fuzzy Sets and Systems, 2010, 161(13): 1871-1883.
%%Uploaded by Yuan Zhong on Sep. 27, 2021. E-mail:yuanzhong66@qq.com.
function select_feature=FRDMAR(data)
%%%input:
% data is data matrix, where rows for samples and columns for attributes. 
% Numerical attributes should be normalized into [0,1] and decision attribute is put in the last column 
% neighbor means the fuzzy radius , usually takes value in [0.05  0.5]
%%%output
% a reduct--- the set of selected attributes.
[row,column]=size(data);
fuzzyradius=zeros(1,column);  
for j=1:column
    if min(data(:,j))==0&&max(data(:,j))==1
     fuzzyradius(j)=1; 
    end
end
%%%%%%%%%%%%%compute the fuzzy relation matrix %%%%%%%%%
    for i=1:column
        col=i;
        r=[];
        eval(['ssr' num2str(col) '=[];']);
        for j=1:row      
            a=data(j,col);
            x=data(:,col);       
            for m=1:length(x)
                r(j,m)=dm_kersim(a,x(m),fuzzyradius(i));
            end
        end
        eval(['ssr' num2str(col) '=r;']);
    end
   rC=ones(row);
   for i=1:column-1
       r_tem=eval(['ssr' num2str(i)]);
       rC=min(rC,r_tem);
   end
   rD=eval(['ssr' num2str(column)]);
  
   [rD_temp,~,rD_ic]=unique(rD,'rows');
   for k=1:size(rD_temp,1)
       i_tem=find(rD_ic==k);
       temp1=min(min(1-rC+repmat(rD_temp(k,:),row,1),ones(row)),[],2);
       temp2(i_tem,:)=repmat(temp1',length(i_tem),1);
   end
       Low=max(temp2,[],1);
%%%%%%%%%%%%%%%%%Calculate fuzzy discernibility matrix%%%%%%%%%%%%%%%%%%%%%
FDM={};
    for i=1:row
        for j=1:row 
            temp_set=[];
            if data(i,column)~=data(j,column)
                l=1;
                for k=1:column-1
                    r1=eval(['ssr' num2str(k)]);
                    if max(0,r1(i,j)+Low(i)-1)==0
                       temp_set(l)=k;
                        l=l+1;
                    end
                end
            end
            FDM(i,j)={temp_set};
        end
    end
    
%%%%%%%%%%%%%%%%%Calculate Reduct%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [row,col]=size(FDM);
    core=[];
    k=1;
    for i=1:row
        for j=1:col

                [~,c1]=size(FDM{i,j});
                if c1==1
                    if ~ismember(FDM{i,j},core)
                        core(k)=FDM{i,j};
                        FDM(i,j)={[]};
                        k=k+1;
                    else
                        FDM(i,j)={[]};
                    end
                end
        end
    end

%<-----------Core calculation done here.Delete those cij with nonempty overlap with Core;---------->
red=core;
while 1
    for i=1:row
        for j=1:col
                if ~isempty(intersect(red,cell2mat(FDM(i,j))))%
                    FDM(i,j)={[]};
                end
        end
    end
    ind = ~cellfun('isempty', FDM);
    c1=FDM(ind);
    TranFDM=cat(2,c1{:});
    if isempty(TranFDM)
        break;
    end
    tab=tabulate(TranFDM);
    [~,e2]=max(tab(:,2));
    red=[red e2]; 
end
select_feature=red;
end
