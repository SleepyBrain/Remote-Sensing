% close all;
% clear all;
% clc;
addpath('F:\CSE 700&800\Data set\10_4231_R7RX991C\aviris_hyperspectral_data');

load AVIRISPCA_train.txt;
X = AVIRISPCA_train;
clear AVIRISPCA_train;

C = X(:,1);
X(:,1:2) = [];

[n,m] = size(X);

nmi = [];
for i = 1:m
    nmi(i) = hs_mut_inf(X(:,i),C)/(sqrt(hs_mut_inf(X(:,i),X(:,i)))*sqrt(hs_mut_inf(C,C)));
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
    for i = 1:20
        if flag(i) == 0 && tmpMI(i) > 0.1
            redun = 0;
            [tmp k] = size(S);
            for j = 1:k
                redun = redun + hs_mut_inf(X(:,i),X(:,S(j)))/(sqrt(hs_mut_inf(X(:,i),X(:,i)))*sqrt(hs_mut_inf(X(:,S(j)),X(:,S(j)))));
            end
            G = hs_mut_inf(X(:,i),C)/(sqrt(hs_mut_inf(X(:,i),X(:,i)))*sqrt(hs_mut_inf(C,C))) - (1/k)*redun;
            if G > mx
                mx = G;
                next = i;
            end
        end
    end
    if mx < 0
        break;
    end
    S(feature) = next;
    flag(next) = 1;
end
%id = S;
