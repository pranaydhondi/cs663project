im = imread('result.jpg');
[p1,p2,p3] = size(im);
im1 = zeros(p1,p2,p3);
flattenvector = flattern(im);
idx = kmeans(flattenvector,100);
count = zeros(100,1);
sum1 = zeros(100,5);
sum1 = double(sum1);
[x,y] = size(flattenvector);
for i=1:x
    count(idx(i)) = count(idx(i)) + 1;
    sum1(idx(i),:) = sum1(idx(i),:) + double(flattenvector(i,:));
end
for i=1:100
    sum1(i,:) = sum1(i,:)/count(i);
end
for j=1:p1
    for k=1:p2
        h = (j-1)*p2 + k;
        im1(j,k,:) = [sum1(idx(h),3) ; sum1(idx(h),4) ; sum1(idx(h),5)];
    end
end
imshow(uint8(im1));
