% p = ([1 1], scales1(1), orients1(1), rgb2gray(im1));

framesdir = './frames/';
siftdir = './sift/';


% Get a list of all the .mat files in that directory.
% There is one .mat file per image.
fnames = dir([siftdir '/*.mat']);

N = 100;  % to visualize a sparser set of the features

desindex = [];
numfeats = 1;
data = [];
dataindex = [];
for i=1:100

    fprintf('reading frame %d of %d\n', i, 400);
    
    % load sift file
    fname = [siftdir '/' fnames(i).name];
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    numfeats = size(descriptors,1);
  
    data = [data ; descriptors];
        
%     features = {descriptors, positions, scales, orients, imname};
%     d = [d ; features];
%     datacell = d(1);
%     indexcell = d(5);    
%     data = [data ; cell2mat(datacell)];
    [ds, ~] = size(data);
    desindex = [ds ; desindex];
    dataindex = [numfeats ; dataindex];
%     dataindex = [dataindex; cell2mat(indexcell)];
        
    % read in the associated image
    imname = [framesdir '/' imname]; % add the full path
    im = imread(imname);
    
%     randinds = randperm(numfeats);

    
%     
%     if size(descriptors,1) > 0
%         numfeats = size(descriptors,1);
%     
%     
%         randframes = randperm(numfeats);
% 
%     features = {descriptors, positions, scales, orients, imname};
%     
%         data = [data ; descriptors(randframes(1:250), :)]; % concaticate correctly
%     end    
%     data = [data ; descriptors];
end
% load('250kmeans.mat');

% words = kmeansML(1500, data);
% datacell = d(1);
% data = cell2mat(datacell);
% numfeats = size(d,1);

[mem, means, e] = kmeansML(1500, data');
kmeans = means';

% select two distinct words cluster
c1 = find(mem == 1000);
m1 = kmeans(1000, :);
c2 = find(mem == 1500);
m2 = kmeans(1500, :);

d1 = data(c1(:), :);
distances1 = dist2(m1, d1);
[sd1, si1] = sort(distances1);

% choose top 25 
md = sd1(1:25);
topminpatches = c1(si1(1:25));

patches = [];
for i=1:25
    if topminpatches(i) < length(fnames)
        fname = [siftdir '/' fnames(topminpatches(i)).name];
    end
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    
    imname = [framesdir '/' imname];
    im = imread(imname);

    p = getPatchFromSIFTParameters(positions(i,:), scales(i,:), ...
        orients(i,:), rgb2gray(im));
%     patches = [p ; patches];
    subplot(5, 5, i);
    imshow(p);
end


d2 = data(c2(:), :);
distances2 = dist2(m2, d2);
[sd2, si2] = sort(distances2);

md2 = sd2(1:25);
sectopminpatches = c2(si2(1:25));

for i=1:25
    if sectopminpatches(i) < length(fnames)
        fname = [siftdir '/' fnames(sectopminpatches(i)).name];
    end
    load(fname, 'imname', 'descriptors', 'positions', 'scales', 'orients');
    
    imname = [framesdir '/' imname];
    im = imread(imname);

    p = getPatchFromSIFTParameters(positions(i,:), scales(i,:), ...
        orients(i,:), rgb2gray(im));
%     patches = [p ; patches];
    subplot(5, 5, i);
    imshow(p);
end