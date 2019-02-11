framesdir = './frames/';
siftdir = './sift/';

fnames = dir([siftdir '/*.mat']);
offset = 59;

fullQueryFrame = 'friends_000000056.jpeg';
qname = [siftdir '/' fnames(613-offset).name];
load(qname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
% load('./sift/friends_0000006666.jpeg.mat');
load('kMeans.mat');

queryDescriptors = descriptors;
M = 5;
qh = dist2(queryDescriptors, kmeans);
 
sq = size(qh, 1);
qindex = [];

for i=1:sq
    [v, qind] = min(qh(i, :));
    qindex = [qindex ; qind];
end
ranges = 1:1501;
qcounts = histcounts(qindex, ranges);

% load('besthist.mat');
visual_search = [];
all_index = [] ;
visual_search = zeros(6612, 1500);
for i=1:length(fnames) % all the frames 
    
    % load sift file
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    numfeats = size(descriptors,1);
    
    wd = dist2(descriptors, kmeans);
    sw = size(wd, 1);
    index = [];

    [~, wi] = min(wd');
    visual_search(i, :) = histc(wi, 1:1500);
    
%     for j=1:sw
%         [v, indx] = min(wd(j, :));
%         index = [index ; indx];
%     end
%     ranges = 1:1501; % ? determine range
%     counts = histcounts(index, ranges);
%     
% %     all_index = [index ; all_index];
%     visual_search = [counts ; visual_search];
end

% all norms
% norms = [];
% hisSize = size(visual_search, 1);
% for i=1:hisSize
%     norms = [norms ; norm(visual_search(i, :))];
% end

% compare the query histogram with visual search
hisSize = size(visual_search, 1);
scores = [];
for i=1:hisSize 
    histogram = visual_search(i, :);
    scores = [ scores ; dot(qcounts, histogram) / ...
        ( norm(histogram) * norm(qcounts) ) ];
end

%ss = scores(not(isnan(scores)));
nan_ind = find(isnan(scores));
scores(nan_ind) = 0;

scores(isnan(scores)) = 0;

% [s, si] = sort(ss);
[s, si] = sort(scores, 'descend');

% topfive = si(size(s, 1) - M + 1: size(s, 1));
topfive = si(1:5);
% index_five = si(1:M+1);

for i=1:M
    name = [siftdir '/' fnames(topfive(i)).name];
    load(name, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    
    imname = [framesdir '/' imname]; % add the full path
    img = imread(imname);
    subplot(1, 5, i);
    imshow(img);
end