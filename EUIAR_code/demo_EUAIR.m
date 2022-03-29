
load('Example.mat');

trandata=Example;
trandata(:,1:2)=normalize(trandata(:,1:2),'range');
lammda=1;
att_num=3;

select_feature_seq=uar_EUIAR(trandata,lammda,att_num)

