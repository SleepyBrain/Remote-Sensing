% close all;
% clear all;
% clc;
load AVIRIS_train.txt;
X = AVIRIS_train;
clear AVIRIS_train;

C = X(:,1);
X(:,1:2) = [];

[n,m] = size(X);
labelNMI = hs_mut_inf(C,C);
nmi = [];
for i = 1:m
    nmi(i) = hs_mut_inf(X(:,i),C)./((sqrt(hs_mut_inf(X(:,i),X(:,i)))*sqrt(labelNMI))+1e-40);
end
tmpMI = nmi;
[nmi,id] = sort(nmi,'descend');

S = id(1);

flag = [];
for i = 1:m
    flag(i) = 0;
end

flag(id(1)) = 1;

for feature = 2:20
    mx = -1;
    next = 0;
    for i = 1:220
        if flag(i) == 0 
            redun = 0;
            [p k] = size(S);
            for j = 1:k
                redun = redun + hs_mut_inf(X(:,i),X(:,S(j)))/(sqrt(hs_mut_inf(X(:,i),X(:,i)))*sqrt(hs_mut_inf(X(:,S(j)),X(:,S(j)))));
            end
            G = hs_mut_inf(X(:,i),C)/(sqrt(hs_mut_inf(X(:,i),X(:,i)))*sqrt(labelNMI)) - (1/k)*redun;
            if G > mx
                mx = G;
                next = i;
            end
        end
    end
    
    S(feature) = next;
    flag(next) = 1;
end
% id = S;
save('PCA+QMI.mat','S');