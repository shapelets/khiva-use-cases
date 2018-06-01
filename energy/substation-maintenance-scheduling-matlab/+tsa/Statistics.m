classdef Statistics < handle
    %% Statistics class
    % TSA Statistics class containing statistics methods.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Grumpy Cat Software S.L.
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    methods(Static)
        function c = covariance(array, unbiased)
            %% COVARIANCE
            % Returns the covariance matrix of the time series contained in tss.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *unbiased* Determines whether it divides by n - 1 (if false)
            % or n (if true).
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libtsac', 'covariance_statistics', ...
                array.getReference(), unbiased, result);
            c = tsa.Array(result);
        end
        
        function m = moment(array, k)
            %% MOMENT
            % Returns the kth moment of the given time series.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *k* The specific moment to be calculated.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libtsac', 'moment_statistics', ...
                array.getReference(), k, result);
            m = tsa.Array(result);
        end
        function ss = sampleStdev(array)
            %% SAMPLESTDEV
            % Estimates standard deviation based on a sample. 
            % The standard deviation is calculated using the "n-1" method.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libtsac', 'sample_stdev_statistics', ...
                array.getReference(), result);
            ss = tsa.Array(result);
        end
         function k = kurtosis(array)
            %% KURTOSIS
            % Returns the kurtosis of tss (calculated with the adjusted 
            % Fisher-Pearson standarized moment coefficient G2).
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libtsac', 'kurtosis_statistics', ...
                array.getReference(), result);
            k = tsa.Array(result);
         end
        function s = skewness(array)
            %% SKEWNESS
            % Calculates the sample skewness of tss (calculated with the 
            % adjusted Fisher-Pearson standardized moment coefficient G1).
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libtsac', 'skewness_statistics', ...
                array.getReference(), result);
            s = tsa.Array(result);
        end
        function q = quantile(array, qArray, precision)
            %% QUANTILE
            % Returns values at the given quantile.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *qArray* Percentile(s) at which to extract score(s). 
            % One or many.
            %
            % *precision* Number of decimals expected.
            result = libpointer('voidPtrPtr');
            [~, ~, ~, result] = calllib('libtsac', 'quantile_statistics', ...
                array.getReference(), qArray.getReference(), precision, result);
            q = tsa.Array(result);
        end
        function qc = quantilesCut(array, quantiles, precision)
            %% QUANTILESCUT
            % Discretizes the time series into equal-sized buckets based 
            % on sample quantiles.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *quantiles* Number of quantiles to extract. From 0 to 1, 
            % step 1/quantiles.
            %
            % *precision* Number of decimals expected.
            result = libpointer('voidPtrPtr');
            [~, ~, ~, result] = calllib('libtsac', 'quantiles_cut_statistics', ...
                array.getReference(), quantiles, precision, result);
            qc = tsa.Array(result);
        end
    end
end