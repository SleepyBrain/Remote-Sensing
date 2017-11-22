cmd=['-t 2 -c ',num2str(bestc), ' -g ', num2str(bestg)]; 
model = svmtrain(label_train,train(:,1:size(id,2)),cmd);
[predict_label, accuracy, dec_values] = svmpredict(label_test, test(:,1:size(id,2)), model);
x = predict_label == label_test;

freq = [];
for i=1:14
    m = find(label_test == i);
    freq(i) = size(m,1);
end

tfreq = [];
for i=1:14
    m = find(label_train == i);
    tfreq(i) = size(m,1);
end


err = [];
for i=1:14
    m = find(label_test == i & x == 0);
    err(i) = size(m,1); 
end

acc = [];
for i=1:14
    acc(i) = (1-err(i)/freq(i))*100;
end