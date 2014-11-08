function result = flattern(im)
    [x,y,z] = size(im);
    result = zeros(x*y,z+2);
    for i=1:x
        for j=1:y
            result((i-1)*y+j,:) = [i,j,im(i,j,1),im(i,j,2),im(i,j,3)];
        end
    end
end