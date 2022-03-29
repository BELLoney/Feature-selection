%% Exploring Unsupervised Interactive Attribute Reduction (EUIAR) algorithm 
%% Please refer to the following papers: 
%% Yuan Zhong, Chen Hongmei,and Li Tianrui. Exploring interactive attribute reduction via
%% fuzzy complementary entropy for unlabeled mixed data[J]. 
%% Pattern Recognition, 2021.
%% Uploaded by Yuan Zhong on Mar. 15, 2022. E-mail:yuanzhong2799@foxmail.com. 
function select_feature=uar_EUIAR(data,lammda,att_num)
%%% input
% data is data matrix without decision attribute, where rows for objects and columns for attributes. 
% Numerical attributes should be normalized into [0,1].
% lammda is is used to adjust the fuzzy radius.
% att_num denotes the number of selected attribute.
%%% output
% a feature sequence for feture significance
[row, attrinu]=size(data);

delta=zeros(1,attrinu);%Initialize the radius  
for j=1:attrinu
    if min(data(:,j))==0&&max(data(:,j))==1
     delta(j)=std(data(:,j),1)/lammda; %Find the radius of the numeric feature
    end
end
%%%%%%%%%%%%%Compute the relation matrix %%%%%%%%%
 for i=1:attrinu
     col=i;
     r=[];
     eval(['ssr' num2str(col) '=[];']);
      for j=1:row      
          a=data(j,col);
          x=data(:,col);       
          for m=1:length(x)
              r(j,m)=euiar_kersim(a,x(m),delta(i));
          end
      end
    eval(['ssr' num2str(col) '=r;']);
 end      
%%%%%%%%%%% Unsupervised Interactive Attribute Reduction%%%%%%%%%%%%%%%%%%%%
unSelect_Fea=[];
Select_Fea=[];
sig=[];
base=ones(row);

E=zeros(1,attrinu);
Joint_E=zeros(attrinu,attrinu);
MI=zeros(attrinu,attrinu);

for j=1:attrinu
     r=eval(['ssr' num2str(j)]);
     E(j)=centropy(r);
end

for i=1:attrinu
       ri=eval(['ssr' num2str(i)]);
    for j=1:i
        rj=eval(['ssr' num2str(j)]);
        Joint_E(i,j)=centropy(min(ri,rj));
        Joint_E(j,i)=Joint_E(i,j);
        MI(i,j)=E(i)+E(j)-Joint_E(i,j);
        MI(j,i)=MI(i,j);
    end
end

[x1,n1]=sort(E,'descend');
sig=[sig x1(1)];
Select_Fea=n1(1);
unSelect_Fea=n1(2:end);

Select_Fea_r=eval(['ssr' num2str(Select_Fea(1))]);
base=min(Select_Fea_r,base);

while length(unSelect_Fea)~=1
    Red=[];
    Joint_E_Red=[];
    Inter=[];
    for i=1:length(unSelect_Fea)
        unSelect_Fea_r=eval(['ssr' num2str(unSelect_Fea(i))]);
        Joint_E_Red(i)=centropy(min(base,unSelect_Fea_r));
        for j=1:length(Select_Fea)
         Red(i,j)=MI(Select_Fea(j),unSelect_Fea(i));
        end
        unSelect_Fea_1=setdiff(unSelect_Fea,unSelect_Fea(i));
        for k=1:length(unSelect_Fea_1)
         rk=eval(['ssr' num2str(unSelect_Fea_1(k))]);
         Inter(i,k)=Joint_E(unSelect_Fea_1(k),unSelect_Fea(i))+centropy(min(unSelect_Fea_r,base))...
             -centropy(min(min(unSelect_Fea_r,rk),base))-E(unSelect_Fea(i));
        end
    end
        [max_sig,max_tem]=max(Joint_E_Red'-mean(Red,2)+mean(Inter,2));
        sig=[sig max_sig];
        Select_Fea_r_max=eval(['ssr' num2str(unSelect_Fea(max_tem))]);
        base=min(Select_Fea_r_max,base);
        Select_Fea=[Select_Fea unSelect_Fea(max_tem)];
        unSelect_Fea=setdiff(unSelect_Fea,unSelect_Fea(max_tem));
end
attribute_sequence=[Select_Fea unSelect_Fea(end)];
select_feature=attribute_sequence(1:att_num);
