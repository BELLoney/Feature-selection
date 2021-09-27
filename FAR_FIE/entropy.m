%%%%% 计算关系矩阵的模糊熵  %%%%%
function [S]=entropy(M)
[a,b]=size(M);
K=0;
for i=1:a
    Si=-(1/a)*log2(sum(M(i,:))/a);
    K=K+Si;
end
S=K;
