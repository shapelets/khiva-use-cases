% -------------------------------------------------------------------
% Copyright (c) 2018 Grumpy Cat Software S.L.
%
% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/.
% -------------------------------------------------------------------

tmp = dir('raw-data/*.csv');
fileList = string.empty(length(tmp),0);
for i = 1:length(tmp)
    fileList(i) = string(tmp(i).name);
end
clear tmp
load preprocessed-data/preprocessed.mat data;

% Creating a TSA array from the matrix
a = tsa.Array(data);
%a = tsa.Normalization.maxMinNorm(a, 1.0, 0.0, 1e-8);

m = ReadMetadata('meta/all_sites.csv');

asoc = tsa.Features.absoluteSumOfChanges(a).getData()';
cam = single(tsa.Features.countAboveMean(a).getData()');
cbm = single(tsa.Features.countBelowMean(a).getData()');
c3 = tsa.Features.c3(a,0).getData()';
mean = tsa.Features.mean(a).getData()';
median = tsa.Features.median(a).getData()';
stdev = tsa.Features.standardDeviation(a).getData()';
cce = tsa.Features.cidCe(a, false).getData()';
k = tsa.Features.kurtosis(a).getData()';
s = tsa.Features.skewness(a).getData()';
lsam = single(tsa.Features.longestStrikeAboveMean(a).getData()');
lsbm = single(tsa.Features.longestStrikeBelowMean(a).getData()');
pordtad = tsa.Features.percentageOfReoccurringDatapointsToAllDatapoints(a, false).getData()';
rbrs = tsa.Features.ratioBeyondRSigma(a, 0.2).getData()';

X = table(asoc, cam, cbm, c3, mean, median, stdev, cce, k, s, lsam, ...
    lsbm, pordtad, rbrs);

idx = kmeans(X{:,:},2);

Y = m(:,2);

t = fitctree(X,Y);
t.view('Mode','graph')

clear a

b = tsa.Array(data(:,1));

[profile, index] = tsa.Matrix.stompSelfJoin(b, 2016);

[md, mi, si] = tsa.Matrix.findBestNMotifs(profile, index, 100);
miH = mi.getData();
siH = si.getData();

for i = 1:100
    figure;
    area([data(miH(i):miH(i)+2016,1), data(siH(i):siH(i)+2016,1)])
    colormap winter
    legend([strcat('motifIndex-', string(miH(i))), strcat('subsequenceIndex-', string(siH(i)))],'Location', 'NorthWest')
    xlim([1 2016])
end

[dd, di, dsi] = tsa.Matrix.findBestNDiscords(profile, index, 50);
diH = di.getData();
dsiH = dsi.getData();

for i = 1:50
    figure;
    area([data(diH(i):diH(i)+2016,1), data(dsiH(i):dsiH(i)+2016,1)])
    colormap winter
    legend([strcat('discordIndex-', string(diH(i))), strcat('subsequenceIndex-', string(dsiH(i)))],'Location', 'NorthWest')
    xlim([1 2016])
end

