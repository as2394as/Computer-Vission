function image = LBP(image)
    image2 = padarray( image , [1,1],'both');
    [r,c] = size(image);
    for i = 2:r-1
        for j = 2:c-1
            t = image(i,j);
            b8 = uint8(image2(i+1,j)>t);
            b7 = uint8(image2(i+1,j-1)>t);
            b6 = uint8(image2(i,j-1)>t);
            b5 = uint8(image2(i-1,j-1)>t);
            b4 = uint8(image2(i-1,j)>t);
            b3 = uint8(image2(i-1,j+1)>t);
            b2 = uint8(image2(i,j+1)>t);
            b1 = uint8(image2(i+1,j+1)>t);
            bit8 = uint8(b8*2^7+b7*2^6+b6*2^5+b5*2^4+b4*2^3+b3*2^2+b2*2+b1);
		    image(i,j)=bit8;
        end
    end

end