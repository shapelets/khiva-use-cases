classdef Backend < int32
    %% BACKEND enumerate
    % Enumeration that indicates the backend to be used.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Shapelets.io
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    enumeration
        KHIVA_BACKEND_DEFAULT (0)
        KHIVA_BACKEND_CPU     (1)
        KHIVA_BACKEND_CUDA    (2)
        KHIVA_BACKEND_OPENCL  (4)
    end
end

