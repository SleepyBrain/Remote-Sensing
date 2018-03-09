function QMI = hs_mut_inf(A,B)
A=double(A);
B=double(B);
[N,M] = size(A);
% 
mua = mean(A(:));
mub = mean(B(:));
% 
sa = std(A(:));
sb = std(B(:));
% 
S=64;
 

A = round((A-mua)*(S/2)/(3*sa))+(S/2);
A = (A<1).*1+(A>S).*S+((A>=1)&(A<=S)).*A;
B = round((B-mub)*(S/2)/(3*sb))+(S/2);
B = (B<1).*1+(B>S).*S+((B>=1)&(B<=S)).*B;

% for i = 1:M
%     A(:,i)=((A(:,i)-min(A(:,i)))/(max(A(:,i))-(min(A(:,i))))*63)+1;
% end
% 
% for i = 1:M
%     B(:,i)=((B(:,i)-min(B(:,i)))/(max(B(:,i))-(min(B(:,i))))*63)+1;
% end
% 
% A = round(A);
% B = round(B);

p = zeros(S,S);
for i = 1:N
    for j = 1:M
        p(A(i,j),B(i,j)) = p(A(i,j),B(i,j))+1;
    end
end

% save p.mat p;

p = p./(N*M);

% figure(2)
% imagesc(log(p+1e-40))
% colormap(gray(256))

[n,m] = size(p);

QMI = 0;

for i = 1:n
    for j = 1:m
       tmp = (p(i,j)-(sum(p(:,j)).*sum(p(i,:))));
       QMI = QMI+ tmp.*tmp ;
    end   
end
QMI = QMI/2;
end