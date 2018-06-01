classdef Array < handle
    %% ARRAY class
    % TSA Array class.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Grumpy Cat Software S.L.
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    properties(Access=private)
        tsaDtype
        arrReference
        dims
    end
    
    methods
        function obj = Array(data)
            %% ARRAY Creates a TSA array
            % Creates a TSA array from a given vector.
            tsa.Library.instance();
            
            if isa(data,'lib.pointer')
                % Creating the Array from an array already present in the
                % device
                dtype = int32(0);
                [obj.arrReference, dtype] = calllib('libtsac', ...
                    'get_type', data, dtype);
                obj.tsaDtype = tsa.Dtype(dtype);
                obj.getDims();
            else
                obj.tsaDtype = tsa.Dtype.fromVariableClass(data);
                ref = libpointer('voidPtrPtr');
                obj.dims = size(data);
                ndims = int64(size(obj.dims));
                ndims = ndims(2);
                if not(isreal(data))
                    % Complex numbers
                    complexData(1,:,:,:,:) = real(data);
                    complexData(2,:,:,:,:) = imag(data);
                    [~, ~, obj.dims, obj.arrReference, ~] = ...
                        calllib('libtsac', 'create_array', complexData, ...
                        ndims, obj.dims, ref, int32(obj.tsaDtype));
                else
                    [~, ~, obj.dims, obj.arrReference, ~] = ...
                        calllib('libtsac', 'create_array', data, ndims, ...
                        obj.dims, ref, int32(obj.tsaDtype));
                end
            end
        end
        
        function dims = getDims(obj)
            %% GETDIMS
            % Get the dimensions of the TSA array.
            dims = int64([1 1 1 1]);
            [obj.arrReference, dims] = calllib('libtsac', 'get_dims', ...
                obj.arrReference, dims);
            obj.dims = dims;
        end
        
        function data = getData(obj)
            %% GETDATA
            % Get the dimensions of the TSA array.
            clazz = tsa.Dtype.toClass(obj.tsaDtype);
            if obj.tsaDtype == tsa.Dtype.c32 || obj.tsaDtype == tsa.Dtype.c64
                complexData = zeros(2 * prod(obj.dims),1, clazz);
                [obj.arrReference, complexData] = calllib('libtsac', ...
                    'get_data', obj.arrReference, complexData);
                complexData = reshape(complexData, [2, obj.dims(1:end)]);
                data = complex(complexData(1, :), complexData(2, :));
                data = reshape(data, obj.getDims());
            else
                data = zeros(obj.getDims(), clazz);
                [obj.arrReference, data] = calllib('libtsac', ...
                    'get_data', obj.arrReference, data);
                data = reshape(data, obj.getDims());
            end
        end
        
        function ref = getReference(obj)
            %% GETREFERENCE
            % Get the reference of the device array.
            ref = obj.arrReference;
        end
        
        function ref = getType(obj)
            %% GETTYPE
            % Get the type of the device array.
            ref = obj.tsaDtype;
        end
        
        function numel = numel(obj)
            %% NUMEL
            % Returns the number of elements in the array. 
            numel = prod(obj.dims);
        end
        
        function print(obj)
            %% PRINT
            % Prints the data stored in the TSA array.
            obj.arrReference = calllib('libtsac', 'print', obj.arrReference);
        end
        
        function size = size(obj)
            %% SIZE
            % Returns the dimensions of the array.
            size = obj.dims;
        end
                
        function delete(obj)
            %% DELETE
            % Releasing the array from the device memory.
            calllib('libtsac', 'delete_array', obj.arrReference);
        end
    end
end

