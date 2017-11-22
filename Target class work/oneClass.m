% close all;
% clear all;
% clc;

load AVIRISPCA_train.txt;
X = AVIRISPCA_train;
clear AVIRISPCA_train;

C = X(:,1);
X(:,1:2) = [];
[n,m] = size(C);
resS = [];

for class = 1:14
    C1(1:n) = 2;
    tmp = find(C==class);
    C1(tmp) = 1;
    C1 = C1';
    tmp  = aprNMI(C1,X);
    for i = 1:size(tmp,2)
        resS(class,i) = tmp(i);
    end
    C1 = [];
end
% save('oneClassFeature.mat','resS');
