% -------------------------------------------------------------------
% Copyright (c) 2018 Grumpy Cat Software S.L.
%
% This Source Code Form is subject to the terms of the Mozilla Public
% License, v. 2.0. If a copy of the MPL was not distributed with this
% file, You can obtain one at http://mozilla.org/MPL/2.0/.
% -------------------------------------------------------------------

function metadata = ReadMetadata(file)
    fid = fopen(file, 'rt');
    a = textscan(fid, '%s %s %s', 'Delimiter',',','HeaderLines',1);
    metadata = [string(a{1}), string(a{2}), string(a{3})];
    metadata = sort(metadata);
    fclose(fid);
end