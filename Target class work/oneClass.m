% close all;
% clear all;
% clc;
addpath('F:\CSE 700&800\Data set\10_4231_R7RX991C\aviris_hyperspectral_data');
 
% load AVIRISPCA_train.txt;
% X = AVIRISPCA_train;
% clear AVIRISPCA_train;

load NewTrain.txt;
X = NewTrain;
clear NewTrain;

C = X(:,1);
X(:,1:2) = [];
tmpC = C;
tmpX = X;

resS = [];

for class = 1:14
    C1 = [];
    X1 = [];
    for i = 1:size(X,1)
        if C(i)==class
            C1 = [C1; 1];
            X1 = [X1; X(i,:)];
        else
            C1 = [C1; 2];
            X1 = [X1; X(i,:)];
        end
        
    end
    tmp  = aprNMI(C1,X1);
    for i = 1:size(tmp,2)
        if tmp(i) == 0
            break;
        end
        resS(class,i) = tmp(i);
    end
    
end
% save('oneClassNMI14.mat','resS');

