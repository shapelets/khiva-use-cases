% -------------------------------------------------------------------
% Copyright (c) 2018 Shapelets.io
%
% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/.
% -------------------------------------------------------------------

tmp = dir('data/*.csv');
fileList = string.empty(length(tmp),0);
for i = 1:length(tmp)
    fileList(i) = string(tmp(i).name);
end
clear tmp
load preprocessed-data/preprocessed.mat data;

% Creating a Khiva array from the matrix
a = khiva.Array(data);
%a = khiva.Normalization.maxMinNorm(a, 1.0, 0.0, 1e-8);

m = ReadMetadata('meta/all_sites.csv');

asoc = khiva.Features.absoluteSumOfChanges(a).getData()';
cam = single(khiva.Features.countAboveMean(a).getData()');
cbm = single(khiva.Features.countBelowMean(a).getData()');
c3 = khiva.Features.c3(a,0).getData()';
mean = khiva.Features.mean(a).getData()';
median = khiva.Features.median(a).getData()';
stdev = khiva.Features.standardDeviation(a).getData()';
cce = khiva.Features.cidCe(a, false).getData()';
k = khiva.Features.kurtosis(a).getData()';
s = khiva.Features.skewness(a).getData()';
lsam = single(khiva.Features.longestStrikeAboveMean(a).getData()');
lsbm = single(khiva.Features.longestStrikeBelowMean(a).getData()');
pordtad = khiva.Features.percentageOfReoccurringDatapointsToAllDatapoints(a, false).getData()';
rbrs = khiva.Features.ratioBeyondRSigma(a, 0.2).getData()';

X = table(asoc, cam, cbm, c3, mean, median, stdev, cce, k, s, lsam, ...
    lsbm, pordtad, rbrs);

idx = kmeans(X{:,:},2);

Y = m(:,2);

t = fitctree(X,Y);
t.view('Mode','graph')

clear a

b = khiva.Array(data(:,1));

[profile, index] = khiva.Matrix.stompSelfJoin(b, 2016);

[md, mi, si] = khiva.Matrix.findBestNMotifs(profile, index, 100);
miH = mi.getData();
siH = si.getData();

for i = 1:100
    figure;
    area([data(miH(i):miH(i)+2016,1), data(siH(i):siH(i)+2016,1)])
    colormap winter
    legend([strcat('motifIndex-', string(miH(i))), strcat('subsequenceIndex-', string(siH(i)))],'Location', 'NorthWest')
    xlim([1 2016])
end

[dd, di, dsi] = khiva.Matrix.findBestNDiscords(profile, index, 50);
diH = di.getData();
dsiH = dsi.getData();

for i = 1:50
    figure;
    area([data(diH(i):diH(i)+2016,1), data(dsiH(i):dsiH(i)+2016,1)])
    colormap winter
    legend([strcat('discordIndex-', string(diH(i))), strcat('subsequenceIndex-', string(dsiH(i)))],'Location', 'NorthWest')
    xlim([1 2016])
end

