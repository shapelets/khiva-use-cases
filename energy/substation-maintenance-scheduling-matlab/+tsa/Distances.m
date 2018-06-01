classdef Distances < handle
    %% Distances class
    % TSA Distances class containing distances methods.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Grumpy Cat Software S.L.
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    methods(Static)
        function e = euclidean(array)
            %% EUCLIDEAN
            % Calculates euclidean distances between time series.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libtsac', 'euclidean', ...
                array.getReference(), result);
            e = tsa.Array(result);
        end
        
        function d = dtw(array)
            %% DTW
            % Calculates the Dynamic Time Warping Distance.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libtsac', 'dtw', ...
                array.getReference(), result);
            d = tsa.Array(result);
        end
        
        function h = hamming(array)
            %% HAMMING
            % Calculates Hamming distances between time series.
            %
            % *array* Expects an input array whose dimension zero is 
            % the length of the time series (all the same) and dimension 
            % one indicates the number of time series.
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libtsac', 'hamming', ...
                array.getReference(), result);
            h = tsa.Array(result);
        end
        
        function m = manhattan(array)
            %% MANHATTAN
            % Calculates Manhattan distances between time series.
            %
            % *array* Expects an input array whose dimension zero is 
            % the length of the time series (all the same) and dimension 
            % one indicates the number of time series.
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libtsac', 'manhattan', ...
                array.getReference(), result);
            m = tsa.Array(result);
        end
        
        function se = squaredEuclidean(array)
            %% SQUAREDEUCLIDEAN
            % Calculates the non squared version of the euclidean distance.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libtsac', 'squared_euclidean', ...
                array.getReference(), result);
            se = tsa.Array(result);
        end
    end
end