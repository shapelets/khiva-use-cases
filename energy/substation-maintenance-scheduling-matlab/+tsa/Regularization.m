classdef Regularization < handle
    %% REGULARIZATION class
    % TSA REGULARIZATION class containing different normalization methods.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Grumpy Cat Software S.L.
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    methods(Static)
        function gb = groupBy(array, aggregationFunction, nColumnsKey, ...
                nColumnsValue)
            %% GROUPBY
            % Group by operation in the input array using nColumnsKey
            % columns as group keys and nColumnsValue columns as values.
            % The data is expected to be sorted. The aggregation function
            % determines the operation to aggregate the values.
            %
            % *array* is an instance of the TSA array class, which points
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
            %
            % *nColumnsKey* Number of columns conforming the key.
            % *nColumnsValue* Number of columns conforming the value (they
            % are expected to be consecutive to the column keys).
            result = libpointer('voidPtrPtr');
            [~, ~, ~, ~, result] = calllib('libtsac', 'group_by', ...
                array.getReference(), aggregationFunction, nColumnsKey, ...
                nColumnsValue, result);
            gb = tsa.Array(result);
        end
    end
end