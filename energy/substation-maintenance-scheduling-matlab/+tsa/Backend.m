classdef Backend < int32
    %% BACKEND enumerate
    % Enumeration that indicates the backend to be used.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Grumpy Cat Software S.L.
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    enumeration
        TSA_BACKEND_DEFAULT (0)
        TSA_BACKEND_CPU     (1)
        TSA_BACKEND_CUDA    (2)
        TSA_BACKEND_OPENCL  (4)
    end
end

