classdef Statistics < handle
    %% Statistics class
    % Khiva Statistics class containing statistics methods.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Shapelets.io
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
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *unbiased* Determines whether it divides by n - 1 (if false)
            % or n (if true).
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'covariance_statistics', ...
                array.getReference(), unbiased, result);
            c = khiva.Array(result);
        end
        function k = kurtosis(array)
            %% KURTOSIS
            % Returns the kurtosis of tss (calculated with the adjusted 
            % Fisher-Pearson standarized moment coefficient G2).
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'kurtosis_statistics', ...
                array.getReference(), result);
            k = khiva.Array(result);
         end
        function ljungBoxOut = ljungBox(tss, lags)
            %% LJUNGBOX
            % The Ljung-Box test checks that data whithin the time series
            % are independently distributed (i.e. the correlations in
            % the population from which the sample is taken are 0, so 
            % that any observed correlations in the data result from
            % randomness of the sampling process). Data are no independently
            % distributed, if they exhibit serial correlation.
            %
            % The test statistic is:
            %
            % $$Q = n\left(n+2\right)\sum_{k=1}^h\frac{\hat{\rho}^2_k}{n-k}$$
            %
            % where ''n'' is the sample size, $\hat{\rho}k$ is the sample 
            % autocorrelation at lag ''k'', and ''h'' is the number of lags 
            % being tested. Under $H_0`$ the statistic Q follows a
            % $\chi^2{(h)}$. For significance level $\alpha$, 
            % the $critical region$ for rejection of the hypothesis 
            % of randomness is:
            % 
            % $$Q > \chi_{1-\alpha,h}^2$$
            %
            % $\chi_{1-\alpha,h}^2$ is the $\alpha$ -quantile of the  
            % chi-squared distribution with ''h'' degrees of freedom.
            %
            % [1] G. M. Ljung  G. E. P. Box (1978). On a measure of lack 
            % of fit in time series models.
            % Biometrika, Volume 65, Issue 2, 1 August 1978, Pages 297-303.
            %
            % *tss* Expects an input array whose dimension zero is the
            % length of the time series (all the same) and dimension
            % one indicates the number of time series.
            %
            % *lags* Number of lags being tested.
            ljungBoxOutPtr = libpointer('voidPtrPtr');
            [~, ~, ljungBoxOutPtr]  = calllib('libkhivac', 'ljung_box', ... 
                tss.getReference(), lags, ljungBoxOutPtr);
            ljungBoxOut = khiva.Array(ljungBoxOutPtr);
        end
        function m = moment(array, k)
            %% MOMENT
            % Returns the kth moment of the given time series.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *k* The specific moment to be calculated.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'moment_statistics', ...
                array.getReference(), k, result);
            m = khiva.Array(result);
        end
        function q = quantile(array, qArray, precision)
            %% QUANTILE
            % Returns values at the given quantile.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *qArray* Percentile(s) at which to extract score(s). 
            % One or many.
            %
            % *precision* Number of decimals expected.
            result = libpointer('voidPtrPtr');
            [~, ~, ~, result] = calllib('libkhivac', 'quantile_statistics', ...
                array.getReference(), qArray.getReference(), precision, result);
            q = khiva.Array(result);
        end
        function qc = quantilesCut(array, quantiles, precision)
            %% QUANTILESCUT
            % Discretizes the time series into equal-sized buckets based 
            % on sample quantiles.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *quantiles* Number of quantiles to extract. From 0 to 1, 
            % step 1/quantiles.
            %
            % *precision* Number of decimals expected.
            result = libpointer('voidPtrPtr');
            [~, ~, ~, result] = calllib('libkhivac', 'quantiles_cut_statistics', ...
                array.getReference(), quantiles, precision, result);
            qc = khiva.Array(result);
        end
        function ss = sampleStdev(array)
            %% SAMPLESTDEV
            % Estimates standard deviation based on a sample. 
            % The standard deviation is calculated using the "n-1" method.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'sample_stdev_statistics', ...
                array.getReference(), result);
            ss = khiva.Array(result);
        end
         
        function s = skewness(array)
            %% SKEWNESS
            % Calculates the sample skewness of tss (calculated with the 
            % adjusted Fisher-Pearson standardized moment coefficient G1).
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'skewness_statistics', ...
                array.getReference(), result);
            s = khiva.Array(result);
        end
    end
end