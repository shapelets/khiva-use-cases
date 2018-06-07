classdef Regression < handle
    %% Distances class
    % Khiva Regression class containing regression methods.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Shapelets.io
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    methods(Static)
        function [slope, intercept, rvalue, pvalue, stdrrest] = ...
                linear(xss, yss)
            %% LINEAR
            % Calculates a linear least-squares regression for two sets of
            % measurements. Both arrays should have the same length.
            %
            % *xss* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % *yss* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            slopeRef = libpointer('voidPtrPtr');
            interceptRef = libpointer('voidPtrPtr');
            rvalueRef = libpointer('voidPtrPtr');
            pvalueRef = libpointer('voidPtrPtr');
            stdrrestRef = libpointer('voidPtrPtr');
            [~, ~, slopeRef, interceptRef, rvalueRef, pvalueRef, ...
                stdrrestRef] = calllib('libkhivac', 'linear', ...
            xss.getReference(), yss.getReference(), slopeRef, ... 
            interceptRef, rvalueRef, pvalueRef, stdrrestRef);
            slope = khiva.Array(slopeRef);
            intercept = khiva.Array(interceptRef);
            rvalue = khiva.Array(rvalueRef);
            pvalue = khiva.Array(pvalueRef);
            stdrrest = khiva.Array(stdrrestRef);
        end
    end
end