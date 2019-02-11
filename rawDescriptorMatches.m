load('twoFrameData.mat');

oi = selectRegion(im1, positions1);
d = descriptors1(oi(:), :);
p = positions1(oi(:), :);
s = scales1(oi(:), :);
o = orients1(oi(:), :);

% displaySIFTPatches(p, s, o, im1);

alldistances = dist2(d, descriptors2);
[sd, ~] = size(alldistances);

allminsclosest = [];
secmins = [];
mins = [];
for i=1:sd
    [mv, mi] = min(alldistances(i, :));
    mins = [mins mv];
    allminsclosest = [allminsclosest mi];
    
    sortedDistances = sort(alldistances(i, :));
    secmins = [secmins sortedDistances(2)];
end


for i=1:sd
    if mins(i)/secmins(i) > 0.75 %threshhold ratio
        allminsclosest(i) = NaN;
    end
end


allminsclosest = allminsclosest(not(isnan(allminsclosest)));
d2 = descriptors2(allminsclosest(:), :);
p2 = positions2(allminsclosest(:), :);
s2 = scales2(allminsclosest(:), :);
o2 = orients2(allminsclosest(:), :);

figure;
imshow(im2);
hold on;
displaySIFTPatches(p2, s2, o2, im2);