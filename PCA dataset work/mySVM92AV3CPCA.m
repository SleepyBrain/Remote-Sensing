% close all;
% clear all;
% clc;
addpath('F:\CSE 700&800\Data set\10_4231_R7RX991C\aviris_hyperspectral_data');
resultPCA = [];

load AVIRISPCA_train.txt;
train = AVIRISPCA_train;
clear AVIRISPCA_train;
label_train = train(:,1);
train(:,1:2)=[];
% train = train(:,1:220);
% train = train(:,idTrain);
train = train(:,id);

load AVIRISPCA_test.txt;
test = AVIRISPCA_test;
clear AVIRISPCA_test;
label_test = test(:,1);
test(:,1:2)=[];
% test = test(:,1:220);
% test = test(:,idTest);
test = test(:,id);

for i=1:size(train, 2)
    train(:,i)=scaledata(train(:,i));
    test(:,i)=scaledata(test(:,i));
end

addpath('F:\CSE 700&800\Data set\libsvm-3.22\matlab');

% bestc=10; bestg=0.83;
bestc=10; bestg=0.28;

%     bestcv=0; bestc=0; bestg=0;
%     for c = 1:10
%         for g = 0.01:0.01:5
%             cmd=['-v 10 -c ',num2str(c), ' -g ', num2str(g)];
%             cv = svmtrain(label_train, train, cmd);
%             if(cv>=bestcv)
%                 bestcv=cv; bestc=c; bestg=g;
%             end
%             fprintf('%g   %g  %g (best c=%g, g=%g, rate=%g)\n', c, g, cv, bestc, bestg, bestcv);
%         end
%     end

cmd=['-t 2 -c ',num2str(bestc), ' -g ', num2str(bestg)];

for f=1:10
    model = svmtrain(label_train,train(:,1:f),cmd);
    [predict_label, accuracy, dec_values] = svmpredict(label_test, test(:,1:f), model);
    resultPCA = [resultPCA accuracy(1)];
end
