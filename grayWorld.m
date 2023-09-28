function gw = grayWorld(image)
    [r,c,ch] = size(image);
    R = image(:,:,1);
    G = image(:,:,2);
    B = image(:,:,3);

    avgR = sum(sum(R))/(r*c);
    avgG = sum(sum(G))/(r*c);
    avgB = sum(sum(B))/(r*c);

    avgimage = mean([avgR avgG avgB]);

    newR = (avgimage/avgR)*(R);
    newG = (avgimage/avgG)*(G);
    newB = (avgimage/avgB)*(B);

    gw(:,:,1) = newR;
    gw(:,:,2) = newG;
    gw(:,:,3) = newB;
end
    
    