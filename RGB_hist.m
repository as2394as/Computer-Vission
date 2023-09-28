function hist = RGB_hist(image)
    totalbins = 8;
    binwidth = 256/totalbins;
    hist = zeros(totalbins,totalbins,totalbins);
    R = image(:,:,1);
    G = image(:,:,2);
    B = image(:,:,3);

    Rhist = floor(double(R)/binwidth)+1;
    Ghist = floor(double(G)/binwidth)+1;
    Bhist = floor(double(B)/binwidth)+1;
    
    [r1,c1] = size(Rhist);
    [r2,c2] = size(Ghist);
    [r3,c3] = size(Bhist);

    bin_image = [reshape(Rhist,r1*c1,1),reshape(Ghist,r2*c2,1),reshape(Bhist,r3*c3,1)];

    for i = 1:length(bin_image)
        a=bin_image(i,1);
        b=bin_image(i,2);
        c=bin_image(i,3);
        hist(a,b,c)=hist(a,b,c)+1;
    end
    hist=hist/sum(sum(sum(hist)));
end