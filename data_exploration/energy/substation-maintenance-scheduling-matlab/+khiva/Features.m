classdef Features < handle
    %% FEATURES class
    % Khiva Features class containing a number of features that can be
    % extracted from time series. All the methods operate with instances
    % of the ARRAY class as input and output.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Shapelets.io
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    methods(Static)
        function ae = absEnergy(array)
            %% ABSENERGY
            % Calculates the sum over the square values of the
            % time series.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'abs_energy', ...
                array.getReference(), result);
            ae = khiva.Array(result);
        end
        
        function asoc = absoluteSumOfChanges(array)
            %% ABSOLUTESUMOFCHANGES
            % Calculates the sum over the absolute value of consecutive
            % changes in the time series.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'absolute_sum_of_changes', ...
                array.getReference(), result);
            asoc = khiva.Array(result);
        end
        
        function aauto = aggregatedAutocorrelation(array, aggregationFunction)
            %% AGGREGATEDAUTOCORRELATION
            % Calculates the value of an aggregation function
            % aggregationFunction (e.g. var or mean) of the autocorrelation
            % (Compare to http://en.wikipedia.org/wiki/Autocorrelation#Estimation),
            % taken over different all possible lags (1 to length of x).
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *aggregationFunction* aggregation_function Function to be
            % used in the aggregation. It receives an integer which
            % indicates the function to be applied:
            %     {
            %         0 : mean,
            %         1 : median
            %         2 : min,
            %         3 : max,
            %         4 : stdev,
            %         5 : var,
            %         default : mean
            %     }
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'aggregated_autocorrelation', ...
                array.getReference(), aggregationFunction, result);
            aauto = khiva.Array(result);
        end
        
        function [slope, intercept, rvalue, pvalue, stdrrest] = ...
            aggregatedLinearTrend(array, chunkSize, aggregationFunction)
            %% AGGREGATEDLINEARTREND
            % Calculates a linear least-squares regression for values of
            % the time series that were aggregated over chunks versus the
            % sequence from 0 up to the number of chunks minus one.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *aggregationFunction* aggregation_function Function to be
            % used in the aggregation. It receives an integer which
            % indicates the function to be applied:
            %     {
            %         0 : mean,
            %         1 : median
            %         2 : min,
            %         3 : max,
            %         4 : stdev,
            %         default : mean
            %     }
            %
            % *slope* Slope of the regression line.
            % 
            % *intercept* Intercept of the regression line.
            % 
            % *rvalue* Intercept of the regression line.
            % 
            % *pvalue* Two-sided p-value for a hypothesis test whose null
            % hypothesis is that the slope is zero, using Wald Test with
            % t-distribution of the test statistic.
            % 
            % *stdrrest* Standard error of the estimated gradient.
            slopeRef = libpointer('voidPtrPtr');
            interceptRef = libpointer('voidPtrPtr');
            rvalueRef = libpointer('voidPtrPtr');
            pvalueRef = libpointer('voidPtrPtr');
            stdrrestRef = libpointer('voidPtrPtr');
            [~, ~, ~, slopeRef, interceptRef, rvalueRef, pvalueRef, stdrrestRef] ...
                = calllib('libkhivac', 'aggregated_linear_trend', ...
                array.getReference(), chunkSize, aggregationFunction, ...
                slopeRef, interceptRef, rvalueRef, pvalueRef, stdrrestRef);
            slope = khiva.Array(slopeRef);
            intercept = khiva.Array(interceptRef);
            rvalue = khiva.Array(rvalueRef);
            pvalue = khiva.Array(pvalueRef);
            stdrrest = khiva.Array(stdrrestRef);
        end
        
        function ae = approximateEntropy(array, m, r)
            %% APROXIMATEENTROPY
            % Calculates a vectorized Approximate entropy algorithm.
            % https://en.wikipedia.org/wiki/Approximate_entropy
            % For short time series this method is highly dependent on
            % the parameters, but should be stable for N > 2000,
            % see: Yentes et al. (2012) - The Appropriate Use of
            % Approximate Entropy and Sample Entropy with Short Data Sets
            % Other shortcomings and alternatives discussed in:
            %   Richman & Moorman (2000) - Physiological time-series
            %   analysis using approximate entropy and sample entropy.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *m* Length of compared run of data.
            % 
            % *r* Filtering level, must be positive.
            result = libpointer('voidPtrPtr');
            [~, ~, ~, result] = calllib('libkhivac', 'approximate_entropy', ...
                array.getReference(), m, r, result);
            ae = khiva.Array(result);
        end
        
        function ac = autoCorrelation(array, maxLag, unbiased)
            %% AUTOCORRELATION
            % Calculates the autocorrelation of the specified lag for
            % the given time series.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *maxLag* The maximum lag to compute.
            % 
            % *unbiased* Determines whether it divides by n - lag (if
            % true) or n (if false).
            result = libpointer('voidPtrPtr');
            [~, ~, ~, result] = calllib('libkhivac', 'auto_correlation', ...
                array.getReference(), maxLag, unbiased, result);
            ac = khiva.Array(result);
        end
        
        function ac = autoCovariance(array, unbiased)
            %% AUTOCOVARIANCE
            % Calculates the auto-covariance of the given time series.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *unbiased* Determines whether it divides by n - lag (if
            % true) or n (if false).
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'auto_covariance', ...
                array.getReference(), unbiased, result);
            ac = khiva.Array(result);
        end
        
        function be = binnedEntropy(array, maxBins)
            %% BINNEDENTROPY
            % Calculates the binned entropy for the given time series and
            % number of bins.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *maxBins* The number of bins.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'binned_entropy', ...
                array.getReference(), maxBins, result);
            be = khiva.Array(result);
        end
        
        function c3 = c3(array, lag)
            %% C3
            % Calculates the Schreiber, T. and Schmitz, A. (1997) measure
            % of non-linearity for the given time series.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *lag* The lag.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'c3', ...
                array.getReference(), lag, result);
            c3 = khiva.Array(result);
        end
        
        function cce = cidCe(array, zNormalize)
            %% CIDCE
            % Calculates an estimate for the time series complexity
            % defined by Batista, Gustavo EAPA, et al (2014). (A more
            % complex time series has more peaks, valleys, etc.).
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *zNormalize* Controls whether the time series should be
            % z-normalized or not.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'cid_ce', ...
                array.getReference(), zNormalize, result);
            cce = khiva.Array(result);
        end
        
        function cam = countAboveMean(array)
            %% COUNTABOVEMEAN
            % Calculates the number of values in the time series that are
            % higher than the mean.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'count_above_mean', ...
                array.getReference(), result);
            cam = khiva.Array(result);
        end
        
        function cbm = countBelowMean(array)
            %% COUNTBELOWMEAN
            % Calculates the number of values in the time series that are
            % lower than the mean.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'count_below_mean', ...
                array.getReference(), result);
            cbm = khiva.Array(result);
        end
        
        function cc = crossCorrelation(xss, yss, unbiased)
            %% CROSSCORRELATION
            % Calculates the cross-correlation of the given time series.
            %
            % *xss* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *yss* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *unbiased* Determines whether it divides by n - lag (if
            % true) or n (if false).
            result = libpointer('voidPtrPtr');
            [~, ~, ~, result] = calllib('libkhivac', 'cross_correlation', ...
                xss.getReference(), yss.getReference(), unbiased, result);
            cc = khiva.Array(result);
        end
        
        function cc = crossCovariance(xss, yss, unbiased)
            %% CROSSCOVARIANCE
            % Calculates the cross-covariance of the given time series.
            %
            % *xss* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *yss* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *unbiased* Determines whether it divides by n - lag (if
            % true) or n (if false).
            result = libpointer('voidPtrPtr');
            [~, ~, ~, result] = calllib('libkhivac', 'cross_covariance', ...
                xss.getReference(), yss.getReference(), unbiased, result);
            cc = khiva.Array(result);
        end
        
        function cwtCoeff = cwtCoefficients(array, width, coeff, w)
            %% CWTCOEFFICIENTS
            % Calculates a Continuous wavelet transform for the Ricker
            % wavelet, also known as the "Mexican hat wavelet" which is
            % defined by:
            %
            % $$ \frac{2}{\sqrt{3a} \pi^{\frac{1} { 4 }}} (1 -
            %   \frac{x^2}{a^2}) exp(-\frac{x^2}{2a^2}) $$
            %
            % where $a$ is the width parameter of the wavelet function.
            %
            % This feature calculator takes three different parameter:
            % widths, coeff and w. The feature calculator takes all
            % the different widths arrays and then calculates the cwt one
            % time for each different width array. Then the values for
            % the different coefficient for coeff and width w are
            % returned. (For each dic in param one feature is returned).
            %   
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *width* Array that contains all different widths.
            %
            % *coeff* Coefficient of interest.
            %
            % *w* Width of interest.
            result = libpointer('voidPtrPtr');
            [~, ~, ~, ~, result] = calllib('libkhivac', 'cwt_coefficients', ...
                array.getReference(), width.getReference(), coeff, w, result);
            cwtCoeff = khiva.Array(result);
        end
        
        function erbc = energyRatioByChunks(array, numSegments, segmentFocus)
            %% ENERGYRATIOBYCHUNKS
            % Calculates the sum of squares of chunk i out of N chunks
            % expressed as a ratio with the sum of squares over the whole
            % series. segmentFocus should be lower than the number of
            % segments.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *numSegments* The number of segments to divide the series
            % into.
            %
            % *segmentFocus* The segment number (starting at zero) to
            % return a feature on.
            result = libpointer('voidPtrPtr');
            [~, ~, ~, result] = calllib('libkhivac', 'energy_ratio_by_chunks', ...
                array.getReference(), numSegments, segmentFocus, result);
            erbc = khiva.Array(result);
        end
        
        function fa = fftAggregated(array)
            %% FFTAGGREGATED
            % Calculates the spectral centroid(mean), variance, skew, and
            % kurtosis of the absolute fourier transform spectrum.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'fft_aggregated', ...
                array.getReference(), result);
            fa = khiva.Array(result);
        end
        
        function [real, imag, absolute, angle] = fftCoefficient(array, ...
                coefficient)
            %% FFTCOEFFICIENT
            % Calculates the fourier coefficients of the one-dimensional
            % discrete Fourier Transform for real input by fast fourier
            % transformation algorithm.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *coefficient* The coefficient to extract from the FFT.
            realRef = libpointer('voidPtrPtr');
            imagRef = libpointer('voidPtrPtr');
            absoluteRef = libpointer('voidPtrPtr');
            angleRef = libpointer('voidPtrPtr');
            [~, ~, realRef, imagRef, absoluteRef, angleRef] ...
                = calllib('libkhivac', 'fft_coefficient', ...
                array.getReference(), coefficient, ...
                realRef, imagRef, absoluteRef, angleRef);
            real = khiva.Array(realRef);
            imag = khiva.Array(imagRef);
            absolute = khiva.Array(absoluteRef);
            angle = khiva.Array(angleRef);
        end
        
        function flom = firstLocationOfMaximum(array)
            %% FIRSTLOCATIONOFMAXIMUM
            % Calculates the first relative location of the maximal value
            % for each time series.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'first_location_of_maximum', ...
                array.getReference(), result);
            flom = khiva.Array(result);
        end
        
        function flom = firstLocationOfMinimum(array)
            %% FIRSTLOCATIONOFMINIMUM
            % Calculates the first location of the minimal value of each
            % time series. The position is calculated relatively to the
            % length of the series.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'first_location_of_minimum', ...
                array.getReference(), result);
            flom = khiva.Array(result);
        end
        
        % Commented because this function fails just in Matlab. It is not
        % failing in python, neither in Java. It is failing when using the
        % lls solver of khiva which uses the svd function of ArrayFire. It
        % fails exactly at the point where svd is used.
        %function fc = friedrichCoefficients(array, m, r)
        %    %% FRIEDRICHCOEFFICIENTS
        %    % Coefficients of polynomial $h(x)$, which has been fitted
        %    % to the deterministic dynamics of Langevin model:
        %    %
        %    %   $$\dot(x)(t) = h(x(t)) + R \mathcal(N)(0,1)$$
        %    %
        %    % as described by [1]. For short time series this method is
        %    % highly dependent on the parameters.
        %    %
        %    % [1] Friedrich et al. (2000): Physics Letters A 271, p. 217-222
        %    % Extracting model equations from experimental data.
        %    %
        %    % *array* is an instance of the Khiva array class, which points
        %    % to an array stored in the device side. Such array might
        %    % contain one or multiple time series (one per column).
        %    %
        %    % *m* Order of polynom to fit for estimating fixed points of
        %    % dynamics.
        %    %
        %    % *r* Number of quantiles to use for averaging.
        %    result = libpointer('voidPtrPtr');
        %    [~, result] = calllib('libkhivac', 'friedrich_coefficients', ...
        %        array.getReference(), m, r, result);
        %    fc = khiva.Array(result);
        %end
        
        function hd = hasDuplicates(array)
            %% HASDUPLICATES
            % Calculates if the input time series contain duplicated
            % elements.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'has_duplicates', ...
                array.getReference(), result);
            hd = khiva.Array(result);
        end
        
        function hdm = hasDuplicateMax(array)
            %% HASDUPLICATEMAX
            % Calculates if the maximum within input time series is
            % duplicated.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'has_duplicate_max', ...
                array.getReference(), result);
            hdm = khiva.Array(result);
        end
        
        function hdm = hasDuplicateMin(array)
            %% HASDUPLICATEMIN
            % Calculates if the maximum within input time series is
            % duplicated.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'has_duplicate_min', ...
                array.getReference(), result);
            hdm = khiva.Array(result);
        end
        
        function imq = indexMassQuantile(array, q)
            %% INDEXMASSQUANTILE
            % Calculates the index of the mass quantile.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *q* The quantile.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'index_mass_quantile', ...
                array.getReference(), q, result);
            imq = khiva.Array(result);
        end
        
        function k = kurtosis(array)
            %% KURTOSIS
            % Returns the kurtosis of array (calculated with the adjusted
            % Fisher-Pearson standardized moment coefficient G2).
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'kurtosis', ...
                array.getReference(), result);
            k = khiva.Array(result);
        end
        
        function lstdev = largeStandardDeviation(array, r)
            %% LARGESTANDARDDEVIATION
            % Checks if the time series within array have a large standard
            % deviation.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *r* The threshold.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'large_standard_deviation', ...
                array.getReference(), r, result);
            lstdev = khiva.Array(result);
        end
        
        function llom = lastLocationOfMaximum(array)
            %% LASTLOCATIONOFMAXIMUM
            % Calculates the last location of the maximum value of each
            % time series. The position is calculated relatively to the
            % length of the series.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'last_location_of_maximum', ...
                array.getReference(), result);
            llom = khiva.Array(result);
        end
        
        function llom = lastLocationOfMinimum(array)
            %% LASTLOCATIONOFMINIMUM
            % Calculates the last location of the minimum value of each
            % time series. The position is calculated relatively to the
            % length of the series.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'last_location_of_minimum', ...
                array.getReference(), result);
            llom = khiva.Array(result);
        end
        
        function l = length(array)
            %% LENGTH
            % Returns the length of the input time series.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'length', ...
                array.getReference(), result);
            l = khiva.Array(result);
        end
        
        function [slope, intercept, rvalue, pvalue, stdrrest] = ...
            linearTrend(array)
            %% LINEARTREND
            % Calculates a linear least-squares regression for values of
            % the time series that were aggregated over chunks versus the
            % sequence from 0 up to the number of chunks minus one.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *aggregationFunction* aggregation_function Function to be
            % used in the aggregation. It receives an integer which
            % indicates the function to be applied:
            %     {
            %         0 : mean,
            %         1 : median
            %         2 : min,
            %         3 : max,
            %         4 : stdev,
            %         default : mean
            %     }
            %
            % *slope* Slope of the regression line.
            % 
            % *intercept* Intercept of the regression line.
            % 
            % *rvalue* Intercept of the regression line.
            % 
            % *pvalue* Two-sided p-value for a hypothesis test whose null
            % hypothesis is that the slope is zero, using Wald Test with
            % t-distribution of the test statistic.
            % 
            % *stdrrest* Standard error of the estimated gradient.
            slopeRef = libpointer('voidPtrPtr');
            interceptRef = libpointer('voidPtrPtr');
            rvalueRef = libpointer('voidPtrPtr');
            pvalueRef = libpointer('voidPtrPtr');
            stdrrestRef = libpointer('voidPtrPtr');
            [~, pvalueRef, rvalueRef, interceptRef, slopeRef, stdrrestRef] ...
                = calllib('libkhivac', 'linear_trend', ...
                array.getReference(), pvalueRef, rvalueRef, ...
                interceptRef, slopeRef, stdrrestRef);
            slope = khiva.Array(slopeRef);
            intercept = khiva.Array(interceptRef);
            rvalue = khiva.Array(rvalueRef);
            pvalue = khiva.Array(pvalueRef);
            stdrrest = khiva.Array(stdrrestRef);
        end
        
        function lm = localMaximals(array)
            %% LOCALMAXIMALS
            % Calculates all Local Maximals for the time series in array.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'local_maximals', ...
                array.getReference(), result);
            lm = khiva.Array(result);
        end
        
        function lsam = longestStrikeAboveMean(array)
            %% LONGESTSTRIKEABOVEMEAN
            % Calculates the length of the longest consecutive subsequence
            % in array that is bigger than the mean of array.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'longest_strike_above_mean', ...
                array.getReference(), result);
            lsam = khiva.Array(result);
        end
        
        function lsbm = longestStrikeBelowMean(array)
            %% LONGESTSTRIKEBELOWMEAN
            % Calculates the length of the longest consecutive subsequence
            % in array that is below the mean of array.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'longest_strike_below_mean', ...
                array.getReference(), result);
            lsbm = khiva.Array(result);
        end
        
        % Commented because this function fails just in Matlab. It is not
        % failing in python, neither in Java. It is failing when using the
        % lls solver of khiva which uses the svd function of ArrayFire. It
        % fails exactly at the point where svd is used.
        %function mlfp = maxLangevinFixedPoint(array, m, r)
        %    %% MAXLANGEVINFIXEDPOINT
        %    % Largest fixed point of dynamics $\max_x {h(x)=0}$ estimated
        %    % from polynomial $h(x)$, which has been fitted to the
        %    % deterministic dynamics of Langevin model
        %    % 
        %    % $$\dot(x)(t) = h(x(t)) + R \mathcal(N)(0,1)$$
        %    % 
        %    % as described by
        %    % Friedrich et al. (2000): Physics Letters A 271, p. 217-222
        %    % *Extracting model equations from experimental data.
        %    %
        %    % *array* is an instance of the Khiva array class, which points
        %    % to an array stored in the device side. Such array might
        %    % contain one or multiple time series (one per column).
        %    %
        %    % *m* Order of polynom to fit for estimating fixed points of
        %    % dynamics.
        %    %
        %    % *r* Number of quantiles to use for averaging.
        %    result = libpointer('voidPtrPtr');
        %    [~, ~, ~, result] = calllib('libkhivac', 'max_langevin_fixed_point', ...
        %        array.getReference(), m, r, result);
        %    mlfp = khiva.Array(result);
        %end
        
        function m = maximum(array)
            %% MAXIMUM
            % Calculates the maximum value for each time series within array.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'maximum', ...
                array.getReference(), result);
            m = khiva.Array(result);
        end
        
        function m = mean(array)
            %% MEAN
            % Calculates the mean value for each time series within array.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'mean', ...
                array.getReference(), result);
            m = khiva.Array(result);
        end
        
        function mac = meanAbsoluteChange(array)
            %% MEANABSOLUTECHANGE
            % Calculates the mean over the absolute differences between
            % subsequent time series values in array.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'mean_absolute_change', ...
                array.getReference(), result);
            mac = khiva.Array(result);
        end
        
        function mc = meanChange(array)
            %% MEANCHANGE
            % Calculates the mean over the differences between subsequent
            % time series values in array.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'mean_change', ...
                array.getReference(), result);
            mc = khiva.Array(result);
        end
        
        function msdc = meanSecondDerivativeCentral(array)
            %% MEANSECONDDERIVATIVECENTRAL
            % Calculates mean value of a central approximation of the
            % second derivative for each time series in array.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'mean_second_derivative_central', ...
                array.getReference(), result);
            msdc = khiva.Array(result);
        end
        
        function m = median(array)
            %% MEDIAN
            % Calculates the median value for each time series within array.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'median', ...
                array.getReference(), result);
            m = khiva.Array(result);
        end
        
        function m = minimum(array)
            %% MINIMUM
            % Calculates the minimum value for each time series within array.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'minimum', ...
                array.getReference(), result);
            m = khiva.Array(result);
        end
        
        function ncm = numberCrossingM(array, m)
            %% NUMBERCROSSINGM
            % Calculates the number of m-crossings. A m-crossing is defined
            % as two sequential values where the first value is lower than
            % $m$ and the next is greater, or viceversa. If you set $m$ to
            % zero, you will get the number of zero crossings.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *m* The m value.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'number_crossing_m', ...
                array.getReference(), m, result);
            ncm = khiva.Array(result);
        end
        
        function ncp = numberCwtPeaks(array, maxW)
            %% NUMBERCWTPEAKS
            % This feature calculator searches for different peaks. To do
            % so, the time series is smoothed by a ricker wavelet and for
            % widths ranging from 1 to max_w. This feature calculator
            % returns the number of peaks that occur at enough width scales
            % and with sufficiently high Signal-to-Noise-Ratio (SNR).
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *maxW* The maximum width to consider.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'number_peaks', ...
                array.getReference(), maxW, result);
            ncp = khiva.Array(result);
        end
        
        function np = numberPeaks(array, n)
            %% NUMBERPEAKS
            % Calculates the number of peaks of at least support $n$ in the
            % time series $array$. A peak of support $n$ is defined as a
            % subsequence of $array$ where a value occurs, which is bigger
            % than its $n$ neighbours to the left and to the right.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *n* The support of the peak.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'number_peaks', ...
                array.getReference(), n, result);
            np = khiva.Array(result);
        end
        
        function pa = partialAutocorrelation(array, lags)
            %% PARTIALAUTOCORRELATION
            % Calculates the value of the partial autocorrelation function
            % at the given lag. The lag $k$ partial autocorrelation of
            % a time series $\lbrace x_t, t = 1 \ldots T \rbrace$ equals
            % the partial correlation of $x_t$ and \f$x_{t-k}\f$, adjusted
            % for the intermediate variables $\lbrace x_{t-1}, \ldots, x_{t-k+1}
            % \rbrace$ ([1]). Following [2], it can be defined as:
            %
            %   $$\alpha_k = \frac{ Cov(x_t, x_{t-k} | x_{t-1}, \ldots,
            %       x_{t-k+1})}{\sqrt{ Var(x_t | x_{t-1}, \ldots, x_{t-k+1})
            %       Var(x_{t-k} | x_{t-1}, \ldots, x_{t-k+1} )}}$$
            %
            % with (a) $x_t = f(x_{t-1}, \ldots, x_{t-k+1})$ and (b)
            % $ x_{t-k} = f(x_{t-1}, \ldots, x_{t-k+1})$ being AR(k-1)
            % models that can be fitted by OLS. Be aware that in (a), the
            % regression is done on past values to predict $ x_t $ whereas
            % in (b), future values are used to calculate the past value
            % $x_{t-k}$. It is said in [1] that "for an AR(p), the partial
            % autocorrelations $\alpha_k$ will be nonzero for $k<=p$ and
            % zero for $k>p$."
            % With this property, it is used to determine the lag of an
            % AR-Process.
            %
            % [1] Box, G. E., Jenkins, G. M., Reinsel, G. C., & Ljung, G. M.
            % (2015). Time series analysis: forecasting and control. John
            % Wiley & Sons.
            %  [2] https://onlinecourses.science.psu.edu/stat510/node/62
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *lags* is an instance of the Khiva array class, which points to
            % the lags to be calculated.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'partial_autocorrelation', ...
                array.getReference(), lags.getReference(), result);
            pa = khiva.Array(result);
        end
        
        function pordtad = percentageOfReoccurringDatapointsToAllDatapoints ...
                (array, isSorted)
            %% PERCENTAGEOFREOCCURRINGDATAPOINTSTOALLDATAPOINTS
            % Calculates the percentage of unique values, that are present
            % in the time series more than once.
            % 
            % $$len(different values occurring more than once) /
            % len(different values)$$
            % 
            % This means the percentage is normalized to the number of
            % unique values, in contrast to the
            % percentageOfReoccurringValuesToAllValues.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *isSorted* Indicates if the input time series is sorted or not.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', ...
                'percentage_of_reoccurring_datapoints_to_all_datapoints', ...
                array.getReference(), isSorted, result);
            pordtad = khiva.Array(result);
        end
        
        function porvtav = percentageOfReoccurringValuesToAllValues ...
                (array, isSorted)
            %% PERCENTAGEOFREOCCURRINGVALUESTOALLVALUES
            % Calculates the percentage of unique values, that are present
            % in the time series more than once.
            %
            %      $$\frac{\textit{number of data points occurring more
            %       than once}}{\textit{number of all data points})}$$
            %
            % This means the percentage is normalized to the number of
            % unique values, in contrast to the
            % percentageOfReoccurringDatapointsToAllDatapoints.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *isSorted* Indicates if the input time series is sorted or not.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', ...
                'percentage_of_reoccurring_values_to_all_values', ...
                array.getReference(), isSorted, result);
            porvtav = khiva.Array(result);
        end
        
        function q = quantile(array, ps, precision)
            %% QUANTILE
            % Returns values at the given quantile.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *ps* Percentile(s) at which to extract score(s). One or many.
            %
            % *precision* Number of decimals expected.
            result = libpointer('voidPtrPtr');
            [~, ~, ~, result] = calllib('libkhivac', 'quantile', ...
                array.getReference(), ps.getReference(), precision, result);
            q = khiva.Array(result);
        end
        
        function rc = rangeCount(array, min, max)
            %% RANGECOUNT
            % Counts observed values within the interval [min, max).
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *min* Value that sets the lower limit.
            %
            % *max* Value that sets the upper limit.
            result = libpointer('voidPtrPtr');
            [~, ~, ~, result] = calllib('libkhivac', 'range_count', ...
                array.getReference(), min, max, result);
            rc = khiva.Array(result);
        end
        
        function rbrs = ratioBeyondRSigma(array, r)
            %% RATIOBEYONDRSIGMA
            % Calculates the ratio of values that are more than
            % $r*std(x)$ (so $r$ sigma) away from the mean of $x$.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *r* Number of times that the values should be away from.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'ratio_beyond_r_sigma', ...
                array.getReference(), r, result);
            rbrs = khiva.Array(result);
        end
        
        function rvnttsl = ratioValueNumberToTimeSeriesLength(array)
            %% RATIOVALUENUMBERTOTIMESERIESLENGTH
            % Calculates a factor which is 1 if all values in the time
            % series occur only once, and below one if this is not the case.
            % In principle, it just returns:
            %
            %      $$\frac{\textit{number_unique_values}}{\textit{number_values}}$$
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'ratio_value_number_to_time_series_length', ...
                array.getReference(), result);
            rvnttsl = khiva.Array(result);
        end
        
        function se = sampleEntropy(array)
            %% SAMPLEENTROPY
            % Calculates a vectorized sample entropy algorithm.
            % https://en.wikipedia.org/wiki/Sample_entropy
            % https://www.ncbi.nlm.nih.gov/pubmed/10843903?dopt=Abstract
            % For short time-series this method is highly dependent on the
            % parameters, but should be stable for N > 2000,
            % see:
            %   Yentes et al. (2012) - The Appropriate Use of Approximate
            %   Entropy and Sample Entropy with Short Data Sets
            % Other shortcomings and alternatives discussed in:
            %   Richman & Moorman (2000) - Physiological time-series
            %   analysis using approximate entropy and sample entropy.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'sample_entropy', ...
                array.getReference(), result);
            se = khiva.Array(result);
        end
        
        function sk = skewness(array)
            %% SKEWNESS
            % Calculates the sample skewness of array (calculated with the
            % adjusted Fisher-Pearson standardized moment coefficient G1).
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'skewness', ...
                array.getReference(), result);
            sk = khiva.Array(result);
        end
        
        function swd = spktWelchDensity(array, coeff)
            %% SPKTWELCHDENSITY
            % Estimates the cross power spectral density of the time series
            % array at different frequencies. To do so, the time series is
            % first shifted from the time domain to the frequency domain.
            %
            % Welch's method computes an estimate of the power spectral
            % density by dividing the data into overlapping segments,
            % computing a modified periodogram for each segment and
            % averaging the periodograms.
            % [1] P. Welch, "The use of the fast Fourier transform for the
            % estimation of power spectra: A method based on time averaging
            % over short, modified periodograms", IEEE Trans. Audio
            % Electroacoust. vol. 15, pp. 70-73, 1967.
            % [2] M.S. Bartlett, "Periodogram Analysis and Continuous
            % Spectra", Biometrika, vol. 37, pp. 1-16, 1950.
            % [3] Rabiner, Lawrence R., and B. Gold. "Theory and Application
            % of Digital Signal Processing" Prentice-Hall, pp. 414-419, 1975.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'spkt_welch_density', ...
                array.getReference(), coeff, result);
            swd = khiva.Array(result);
        end
        
        function stdev = standardDeviation(array)
            %% STANDARDDEVIATION
            % Calculates the standard deviation of each time series within
            % array.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'standard_deviation', ...
                array.getReference(), result);
            stdev = khiva.Array(result);
        end
        
        function sord = sumOfReoccurringDatapoints(array, isSorted)
            %% SUMOFREOCCURINGDATAPOINTS
            % Calculates the sum of all data points, that are present in
            % the time series more than once.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *isSorted* Indicates if the input time series is sorted or not.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'sum_of_reoccurring_datapoints', ...
                array.getReference(), isSorted, result);
            sord = khiva.Array(result);
        end
        
        function sorv = sumOfReoccurringValues(array, isSorted)
            %% SUMOFREOCCURINGVALUES
            % Calculates the sum of all values, that are present in the
            % time series more than once.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *isSorted* Indicates if the input time series is sorted or not.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'sum_of_reoccurring_values', ...
                array.getReference(), isSorted, result);
            sorv = khiva.Array(result);
        end
        
        function sv = sumValues(array)
            %% SUMVALUES
            % Calculates the sum over the time series array.
            %
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'sum_values', ...
                array.getReference(), result);
            sv = khiva.Array(result);
        end
        
        function sl = symmetryLooking(array, r)
            %% SYMMETRYLOOKING
            % Calculates if the distribution of array%looks symmetric*.
            % This is the case if
            % 
            % $$| mean(array)-median(array)| < r * (max(array)-min(array))$$
            % 
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *r* The percentage of the range to compare with.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'symmetry_looking', ...
                array.getReference(), r, result);
            sl = khiva.Array(result);
        end
        
        function tras = timeReversalAsymmetryStatistic(array, lag)
            %% TIMEREVERSALASYMMETRYSTATISTIC
            % This function calculates the value of:
            %
            %      $$\frac{1}{n-2lag} \sum_{i=0}^{n-2lag} x_{i + 2 \cdot
            %       lag}^2 \cdot x_{i + lag} - x_{i + lag} \cdot  x_{i}^2$$
            %
            % which is
            %
            %       $$\mathbb{E}[L^2(X)^2 \cdot L(X) - L(X) \cdot X^2]$$
            %
            % where $\mathbb{E}$ is the mean and $L$ is the lag operator.
            % It was proposed in [1] as a promising feature to extract from
            % time series.
            %
            % [1] Fulcher, B.D., Jones, N.S. (2014). Highly comparative
            % feature-based time-series classification. Knowledge and Data
            % Engineering, IEEE Transactions on 26, 3026–3037.
            % 
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *lag* The lag to be computed.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'time_reversal_asymmetry_statistic', ...
                array.getReference(), lag, result);
            tras = khiva.Array(result);
        end
        
        function vc = valueCount(array, v)
            %% VALUECOUNT
            % Counts occurrences of value in the time series array.
            % 
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            % 
            % *v* The value to be counted.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'value_count', ...
                array.getReference(), v, result);
            vc = khiva.Array(result);
        end
        
        function v = variance(array)
            %% VARIANCE
            % Computes the variance for the time series array.
            % 
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'variance', ...
                array.getReference(), result);
            v = khiva.Array(result);
        end
        
        function v = varianceLargerThanStandardDeviation(array)
            %% VARIANCELARGERTHANSTANDARDDEVIATION
            % Calculates if the variance of array is greater than the
            % standard deviation. In other words, if the variance of array
            % is larger than 1.
            % 
            % *array* is an instance of the Khiva array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', ...
                'variance_larger_than_standard_deviation', ...
                array.getReference(), result);
            v = khiva.Array(result);
        end
    end
end
