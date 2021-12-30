load Example

trandata=Example;
trandata(:,1:2)=normalize(trandata(:,1:2),'range');
delta_val=0.1; 
var=0.001;

select_feature_seq=uar_HKCMI(trandata,var,delta_val)


