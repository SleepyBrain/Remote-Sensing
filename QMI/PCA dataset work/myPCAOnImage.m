Image = imread('19920612_AVIRIS_IndianPine_Site3.tif');
[r, c, b] = size(Image);

for i = 1:5
figure,colormap(gray), imagesc(Image(:,:,i));%added by sir
end

newRow = r*c;
image = reshape(Image,newRow,b);
meanImage = mean(image);
imageAd = bsxfun(@minus,double(image),meanImage);

covMat = cov(imageAd);
[eigVector,eigValue] = eig(covMat,'nobalance');
[eigValue,idx] = sort(diag(eigValue),'descend');
eigVector = eigVector(:,idx(1:1:end));%sorting eigenvector according to significance
preFinal = eigVector'*imageAd';
finalData = preFinal';
imagePCA=uint16(finalData);
imagePCA=reshape(imagePCA, r, c, b);

for i = 1:10
figure,colormap(gray), imagesc(imagePCA(:,:,i));%added by sir
end

total = eigValue(1);
cum(1) = eigValue(1);
for i=2:b
    cum(i) = eigValue(i)+cum(i-1);
    total = total+eigValue(i);
end

for i=1:b
    per(i) = (eigValue(i)/total)*100;
    var(i) = (cum(i)/total)*100;
end

% multibandwrite(imagePCA,'site3PCA.tif','bsq');

%recovImage = eigVector*preFinal;
%recovImage = recovImage';
%recovImage = bsxfun(@plus,recovImage,meanImage);
%recovImage = uint16(recovImage);
%recovImage = reshape(recovImage,r,c,b);
