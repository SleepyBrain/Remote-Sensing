% close all;
% clear all;
% clc;
clearvars -except resS oneClassC oneClassG
addpath('F:\CSE 700&800\Data set\10_4231_R7RX991C\aviris_hyperspectral_data');

oneClassRes = [];

for class = 1:14
    resultPCA = [];
    load AVIRISPCA_train.txt;
    train = AVIRISPCA_train;
    clear AVIRISPCA_train;
    C = train(:,1);
    train(:,1:2)=[];
    
    [n,m] = size(train);
    label(1:n) = 2;
    tmp = find(C==class);
    label(tmp) = 1;
    label_train = label';
    train = train(:,resS(class,:));
    
    C = [];
    load AVIRISPCA_test.txt;
    test = AVIRISPCA_test;
    clear AVIRISPCA_test;
    C = test(:,1);
    test(:,1:2)=[];
    label=[];
    [n,m] = size(test);
    label(1:n) = 2;
    tmp = find(C==class);
    label(tmp) = 1;
    label_test = label';
    C = [];
    
    test = test(:,resS(class,:));
    
    for i=1:size(train, 2)
        train(:,i)=scaledata(train(:,i));
        test(:,i)=scaledata(test(:,i));
    end
    
    addpath('F:\CSE 700&800\Data set\libsvm-3.22\matlab');
    
    bestc=oneClassC(class); bestg=oneClassG(class);
%       bestc=5; bestg=0.75;
    
    cmd=['-t 2 -c ',num2str(bestc), ' -g ', num2str(bestg)];
    
    for f=1:20
        model = svmtrain(label_train,train(:,1:f),cmd);
        [predict_label, accuracy, dec_values] = svmpredict(label_test, test(:,1:f), model);
        resultPCA = [resultPCA accuracy(1)];
    end
    
    oneClassRes = [oneClassRes; resultPCA];
end
tcoRes = [];
for i=1:8
    tcoRes(i) = mean(oneClassRes(:,i));
end