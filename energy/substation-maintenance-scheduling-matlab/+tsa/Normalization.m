classdef Normalization < handle
    %% NORMALIZATION class
    % TSA Normalization class containing different normalization methods.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Grumpy Cat Software S.L.
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    methods(Static)
        function dsn = decimalScalingNorm(array)
            %% DECIMALSCALINGNORM
            % Normalizes the given time series according to its maximum
            % value and adjusts each value within the range (-1, 1).
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libtsac', ...
                'decimal_scaling_norm', array.getReference(), result);
            dsn = tsa.Array(result);
        end
        
        function decimalScalingNormInPlace(array)
            %% DECIMALSCALINGNORMINPLACE
            % Same as decimalScalingNorm, but it performs the operation
            % in place, without allocating further memory.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            calllib('libtsac', 'decimal_scaling_norm_in_place', ...
                array.getReference());
        end
        
        function mmn = maxMinNorm(array, high, low, epsilon)
            %% MAXMINNORM
            % Normalizes the given time series according to its minimum and
            % maximum value and adjusts each value within the range
            % [low, high].
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *high* Maximum final value (Defaults to 1.0).
            %
            % *low* Minimum final value (Defaults to 0.0).
            %
            % *epsilon* Minimum standard deviation to consider. It acts as
            % a gatekeeper for those time series that may be constant or
            % near constant.
            result = libpointer('voidPtrPtr');
            [~, ~, ~, ~, result] = calllib('libtsac', 'max_min_norm', ...
                array.getReference(), high, low, epsilon, result);
            mmn = tsa.Array(result);
        end
        
        function maxMinNormInPlace(array, high, low, epsilon)
            %% MAXMINNORMINPLACE
            % Same as maxMinNorm, but it performs the operation in place,
            % without allocating further memory.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *high* Maximum final value (Defaults to 1.0).
            %
            % *low* Minimum final value (Defaults to 0.0).
            %
            % *epsilon* Minimum standard deviation to consider. It acts as
            % a gatekeeper for those time series that may be constant or
            % near constant.
            calllib('libtsac', 'max_min_norm_in_place', array.getReference(), ...
                high, low, epsilon);
        end
        
        function dsn = meanNorm(array)
            %% MEANNORM
            % Normalizes the given time series according to its 
            % maximum-minimum value and its mean. It follows the following
            % formulae:
            %
            %   $$\acute{x} = \frac{x - mean(x)}{max(x) - min(x)}.$$
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libtsac', ...
                'mean_norm', array.getReference(), result);
            dsn = tsa.Array(result);
        end
        
        function meanNormInPlace(array)
            %% MEANNORMINPLACE
            % Normalizes the given time series according to its 
            % maximum-minimum value and its mean. It follows the following
            % formulae:
            %
            %   $$\acute{x} = \frac{x - mean(x)}{max(x) - min(x)}.$$
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            calllib('libtsac', 'mean_norm_in_place', ...
                array.getReference());
        end
        
        function zn = zNorm(array, epsilon)
            %% ZNORM
            % Calculates a new set of time series with zero mean and
            % standard deviation one.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *epsilon* Minimum standard deviation to consider. It acts as
            % a gatekeeper for those time series that may be constant or
            % near constant.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libtsac', 'znorm', ...
                array.getReference(), epsilon, result);
            zn = tsa.Array(result);
        end
        
        function zNormInPlace(array, epsilon)
            %% ZNORMINPLACE
            % Adjusts the time series in the given input and performs
            % z-norm inplace (without allocating further memory).
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *epsilon* Minimum standard deviation to consider. It acts as
            % a gatekeeper for those time series that may be constant or
            % near constant.
            calllib('libtsac', 'znorm_in_place', ...
                array.getReference(), epsilon);
        end
    end
end