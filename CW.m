%% Unzip and extract images to store in variable

%seed for the random number generator
groundtruth = readtable('groundtruth.txt','ReadVariableNames', false);
names = unzip('lesionimages.zip');
snames = unzip('masks.zip');
nfiles = length(names);
sn = length(snames);

% extracting images from zip files
for j=1:nfiles
   currentimage = histeq(imread(names{j}));
   images{j} = currentimage;
end

% extracting masks from zip files
for i=1:sn
   currentmask = imread(snames{i});
   mask_images{i} = currentmask;
end

%% Using segmented image to remove background

for m = 1:200
    cell_image = images{m};
    c1 = cell_image(:,:,1);
    c2 = cell_image(:,:,2);
    c3 = cell_image(:,:,3);
    mask = mask_images{m};
    c1(~mask) = 255;
    c2(~mask) = 255;
    c3(~mask) = 255;
    cell_image(:,:,1)=c1;
    cell_image(:,:,2)=c2;
    cell_image(:,:,3)=c3;
    roi_images{m}=cell_image;
end

%% Colour Feature Extraction

for k = 1:nfiles
    colour_histograms{k} = reshape(RGB_hist(grayWorld(roi_images{k})),512,1);
end

colour_features1 = cell2mat(colour_histograms);

%% Texture Feature Extraction

for l = 1:sn
    binaryPattern{l} = hist_lbp(LBP(rgb2gray(roi_images{l})));
end

texture_features1 = cell2mat(binaryPattern);

%% Feature selection

warning('off', 'stats:pca:ColRankDefX')

features = [texture_features1',colour_features1'];

[coeff,score,latent,tsquared,explained] = pca(features);

features = score(:,1);

%% SVM Code which accepts features

imfeatures = features;
groundtruth = table2array(groundtruth(:,2));

% perform classification using 10CV
rng(1); % let's all use the same seed for the random number generator
svm = fitcsvm(imfeatures, groundtruth);
cvsvm = crossval(svm);
pred = kfoldPredict(cvsvm);
[cm, order] = confusionmat(groundtruth, pred);

%% Results

tp = cm(1,1); % True Positive
fp = cm(1,2); % False Positive
fn = cm(2,1); % False Negative
tn = cm(2,2); % True Negative

accuracy =(tp+tn)/(tp+fp+tn+fn);
missclassification_rate =(fp+fn)/(fp+fn+tp+tn);
precision =tp/(tp + fp);
sensitivity =tp/(tp + fn);
specificity =tn/(tn + fp);

Y = categorical({'accuracy','precision','sensitivity','specificity','missclassification_rate'});
Y = reordercats(Y,{'accuracy','precision','sensitivity','specificity','missclassification_rate'});
X = [accuracy*100,precision*100,sensitivity*100,specificity*100,missclassification_rate*100];
bar(Y,X);
ylim([0,100])