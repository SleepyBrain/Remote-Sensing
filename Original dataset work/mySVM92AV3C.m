% close all;
% clear all;
% clc;
resultOrg = [];

%training data
load AVIRIS_train.txt;
train = AVIRIS_train;
clear AVIRIS_train;

label_train = train(:,1);
train(:,1:2)=[];
% train = train(:,1:8);
train = train(:,S);


%test data
load AVIRIS_test.txt;
test = AVIRIS_test;
clear AVIRIS_test;

label_test = test(:,1);
test(:,1:2)=[];
% test = test(:,1:8);
test = test(:,S);



for i=1:size(train, 2)
    train(:,i)=scaledata(train(:,i));
    test(:,i)=scaledata(test(:,i));
end

addpath('F:\CSE 700&800\Data set\libsvm-3.22\matlab');

% bestc=10;bestg=2.85;
bestc=10;bestg=2.44;

cmd=['-t 2 -c ',num2str(bestc), ' -g ', num2str(bestg)];
for f=1:size(S,2)
    model = svmtrain(label_train,train(:,1:f),cmd);
    [predict_label, accuracy, dec_values] = svmpredict(label_test, test(:,1:f), model);
    resultOrg = [resultOrg accuracy(1)];
end
% save('Org+NMI.mat','S','resultOrg','bestc','bestg');