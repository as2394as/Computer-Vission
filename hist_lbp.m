function hist = hist_lbp(image)
        lbp = LBP(image);
        hlist = unique(lbp);
        hist = zeros(256,1);
        for i = 1:256
            b = sum(lbp==i-1,'all');
            hist(i) = b;
        end
end