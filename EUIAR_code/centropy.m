%%%%% 计算关系矩阵的模糊互补熵  %%%%%
function [S]=centropy(M)
[a,~]=size(M);
K=0;
for i=1:a
    Si=(1/a)*(1-sum(M(i,:))/a);
    K=K+Si;
    Si=0;
end
S=K;
