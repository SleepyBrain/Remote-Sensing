% close all;
% clear all;
% clc;
clearvars -except resS oneClassC oneClassG
addpath('F:\CSE 700&800\Data set\10_4231_R7RX991C\aviris_hyperspectral_data');

oneClassRes = [];
% oneClassC = [];
% oneClassG = [];


for class = 1:14
    resultPCA = [];
    load AVIRISPCA_train.txt;
    train = AVIRISPCA_train;
    clear AVIRISPCA_train;
    label_train = train(:,1);
    train(:,1:2)=[];
    
    C = label_train;
    X = train;
    
    label_train = [];
    train = [];
    
    for i = 1:size(X,1)
        if C(i)==class
            label_train = [label_train; 1];
            train = [train; X(i,:)];
        else
            label_train = [label_train; 2];
            train = [train; X(i,:)];
        end
        
    end
    train = train(:,resS(class,:));
    
    load AVIRISPCA_test.txt;
    test = AVIRISPCA_test;
    clear AVIRISPCA_test;
    label_test = test(:,1);
    test(:,1:2)=[];
    
    C = label_test;
    X = test;
    
    label_test = [];
    test = [];
    
    for i = 1:size(X,1)
        if C(i)==class
            label_test = [label_test; 1];
            test = [test; X(i,:)];
        else
            label_test = [label_test; 2];
            test = [test; X(i,:)];
        end
        
    end
    test = test(:,resS(class,:));
    
    for i=1:size(train, 2)
        train(:,i)=scaledata(train(:,i));
        test(:,i)=scaledata(test(:,i));
    end
    
    addpath('F:\CSE 700&800\Data set\libsvm-3.22\matlab');
    
    bestc=oneClassC(class); bestg=oneClassG(class);
    
    %             bestcv=0; bestc=0; bestg=0;
    %             for c = 1:10
    %                 for g = 0.01:0.01:3
    %                     cmd=['-v 10 -c ',num2str(c), ' -g ', num2str(g)];
    %                     cv = svmtrain(label_train, train, cmd);
    %                     if(cv>=bestcv)
    %                         bestcv=cv; bestc=c; bestg=g;
    %                     end
    %                     fprintf('%g   %g  %g (best c=%g, g=%g, rate=%g)\n', c, g, cv, bestc, bestg, bestcv);
    %                 end
    %             end
    
    cmd=['-t 2 -c ',num2str(bestc), ' -g ', num2str(bestg)];
    
    for f=1:20
        model = svmtrain(label_train,train(:,1:f),cmd);
        [predict_label, accuracy, dec_values] = svmpredict(label_test, test(:,1:f), model);
        resultPCA = [resultPCA accuracy(1)];
    end
    
%     oneClassC = [oneClassC bestc];
%     oneClassG = [oneClassG bestg];
    oneClassRes = [oneClassRes; resultPCA];
end

% for i =  1:14
%     plot(oneClassRes(i,:));
%     hold on;
% end
% hold off

% for i =  1:14
%     figure();
%     plot(resultRBF(i,:));
%     hold on;
%     plot(oneClassRes(i,:));
%     hold off;
% end
% save('oneClassRes14Full.mat','oneClassRes');