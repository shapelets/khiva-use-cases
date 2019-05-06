classdef Array < matlab.mixin.Copyable
    %% ARRAY class
    % Khiva Array class.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Shapelets.io
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    properties(Access=private)
        arrReference
    end
    
    properties(Access=public)
        khivaDtype
        dims
    end
    
    methods(Access = protected)
        % Override copyElement method:
        function cpObj = copyElement(obj)
            % Make a shallow copy of all three properties
            cpObj = copyElement@matlab.mixin.Copyable(obj);
            % Make a copy of the array on the device
            cpObj.arrReference = libpointer('voidPtrPtr');
            [~, cpObj.arrReference] = calllib('libkhivac', 'copy', ...
                obj.arrReference, cpObj.arrReference);
        end
    end
    
    methods
        function obj = Array(data)
            %% ARRAY Creates a Khiva array
            % Creates a Khiva array from a given vector.
            khiva.Library.instance();
            
            if isa(data,'lib.pointer')
                % Creating the Array from an array already present in the
                % device
                dtype = int32(0);
                [obj.arrReference, dtype] = calllib('libkhivac', ...
                    'get_type', data, dtype);
                obj.khivaDtype = khiva.Dtype(dtype);
                obj.getDims();
            else
                obj.khivaDtype = khiva.Dtype.fromVariableClass(data);
                ref = libpointer('voidPtrPtr');
                obj.dims = size(data);
                ndims = int64(size(obj.dims));
                ndims = ndims(2);
                if not(isreal(data))
                    % Complex numbers
                    complexData(1,:,:,:,:) = real(data);
                    complexData(2,:,:,:,:) = imag(data);
                    [~, ~, obj.dims, obj.arrReference, ~] = ...
                        calllib('libkhivac', 'create_array', complexData, ...
                        ndims, obj.dims, ref, int32(obj.khivaDtype));
                else
                    [~, ~, obj.dims, obj.arrReference, ~] = ...
                        calllib('libkhivac', 'create_array', data, ndims, ...
                        obj.dims, ref, int32(obj.khivaDtype));
                end
            end
        end
        
        function dims = getDims(obj)
            %% GETDIMS
            % Get the dimensions of the Khiva array.
            dims = int64([1 1 1 1]);
            [obj.arrReference, dims] = calllib('libkhivac', 'get_dims', ...
                obj.arrReference, dims);
            obj.dims = dims;
        end
        
        function data = getData(obj)
            %% GETDATA
            % Get the dimensions of the Khiva array.
            clazz = khiva.Dtype.toClass(obj.khivaDtype);
            if obj.khivaDtype == khiva.Dtype.c32 || obj.khivaDtype == khiva.Dtype.c64
                complexData = zeros(2 * prod(obj.dims),1, clazz);
                [obj.arrReference, complexData] = calllib('libkhivac', ...
                    'get_data', obj.arrReference, complexData);
                complexData = reshape(complexData, [2, obj.dims(1:end)]);
                data = complex(complexData(1, :), complexData(2, :));
                data = reshape(data, obj.getDims());
            else
                data = zeros(obj.getDims(), clazz);
                [obj.arrReference, data] = calllib('libkhivac', ...
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
            ref = obj.khivaDtype;
        end
        
        function numel = numel(obj)
            %% NUMEL
            % Returns the number of elements in the array. 
            numel = prod(obj.dims);
        end
        
        function print(obj)
            %% PRINT
            % Prints the data stored in the Khiva array.
            obj.arrReference = calllib('libkhivac', 'print', obj.arrReference);
        end
        
        function size = size(obj)
            %% SIZE
            % Returns the dimensions of the array.
            size = obj.dims;
        end
                
        function delete(obj)
            %% DELETE
            % Releasing the array from the device memory.
            calllib('libkhivac', 'delete_array', obj.arrReference);
        end
        
        %% Operators overloading
        function obj3 = plus(obj1, obj2)
            %% PLUS
            % Plus operator overloading. Adds *obj1* and *obj2* and stores
            % the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_add', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = times(obj1, obj2)
            %% TIMES
            % Times operator overloading. Element-wise multiplication of
            % *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_mul', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = minus(obj1, obj2)
            %% MINUS
            % Minus operator overloading. Subtracts *obj2* from *obj1* and
            % stores the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_sub', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = rdivide(obj1, obj2)
            %% RDIVIDE
            % Rdivide operator overloading. Element-wise right division of
            % *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_div', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = mod(obj1, obj2)
            %% MOD
            % Mod operator overloading. Remainder after division (modulo
            % operation) of *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_mod', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = power(obj1, obj2)
            %% POWER
            % Power operator overloading. Element-wise power of
            % *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_pow', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = lt(obj1, obj2)
            %% LT
            % Lt operator overloading. Less than of
            % *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_lt', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = gt(obj1, obj2)
            %% GT
            % Gt operator overloading. Greater than of
            % *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_gt', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = le(obj1, obj2)
            %% LE
            % Le operator overloading. Less or equal than of
            % *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_le', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = ge(obj1, obj2)
            %% GE
            % Ge operator overloading. Greater or equal than of
            % *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_ge', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = eq(obj1, obj2)
            %% EQ
            % Eq operator overloading. Equal to of
            % *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_eq', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = ne(obj1, obj2)
            %% NE
            % Ne operator overloading. Not equal to of
            % *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_ne', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = and(obj1, obj2)
            %% AND
            % And operator overloading. Logical AND of
            % *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_bitand', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = or(obj1, obj2)
            %% OR
            % Or operator overloading. Logical OR of
            % *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_bitor', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj3 = xor(obj1, obj2)
            %% XOR
            % Xor operator overloading. Logical exclusive-OR of
            % *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_bitxor', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function obj2 = bitshift(obj1, n)
            %% BITSHIFT
            % Bitshift operator overloading. Shift bits specified number of
            % places of *obj1* and *n* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_bitshiftl', ...
                obj1.getReference(), n, result);
            obj2 = khiva.Array(result);
        end
        
        function obj2 = bitsra(obj1, n)
            %% BITSRA
            % Bitsra operator overloading. Bit shift right arithmetic of
            % *obj1* and *n* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_bitshiftr', ...
                obj1.getReference(), n, result);
            obj2 = khiva.Array(result);
        end
        
        function obj2 = not(obj1)
            %% NOT
            % Not operator overloading. Logical NOT of
            % *obj1* and *n* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'khiva_not', ...
                obj1.getReference(), result);
            obj2 = khiva.Array(result);
        end
        
        function obj2 = ctranspose(obj1)
            %% CTRANSPOSE
            % Ctranspose operator overloading. Complex conjugate transpose
            % of *obj1* and *n* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_transpose', ...
                obj1.getReference(), true, result);
            obj2 = khiva.Array(result);
        end
        
        function obj2 = transpose(obj1)
            %% TRANSPOSE
            % Transpose operator overloading. Matrix transpose
            % of *obj1* and *n* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_transpose', ...
                obj1.getReference(), false, result);
            obj2 = khiva.Array(result);
        end
        
        function c = col(obj, i)
            %% COL
            % Retrieving a given column of the array.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_col', ...
                obj.getReference(), i, result);
            c = khiva.Array(result);
        end
        
        function c = cols(obj, start, endd)
            %% COLS
            % Retrieving columns from *start* to *endd* of the array,
            % both inclusive.
            result = libpointer('voidPtrPtr');
            [~, ~, ~, result] = calllib('libkhivac', 'khiva_cols', ...
                obj.getReference(), start, endd, result);
            c = khiva.Array(result);
        end
        
        function r = row(obj, i)
            %% ROW
            % Retrieving a given row of the array.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_row', ...
                obj.getReference(), i, result);
            r = khiva.Array(result);
        end
        
        function r = rows(obj, start, endd)
            %% ROWS
            % Retrieving rows from *start* to *endd* of the array,
            % both inclusive.
            result = libpointer('voidPtrPtr');
            [~, ~, ~, result] = calllib('libkhivac', 'khiva_rows', ...
                obj.arrReference, start, endd, result);
            r = khiva.Array(result);
        end
        
        function obj3 = mtimes(obj1, obj2)
            %% MTIMES
            % Mtimes operator overloading. Matrix multiplication of
            % *obj1* and *obj2* storing the result in *obj3*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_matmul', ...
                obj1.getReference(), obj2.getReference(), result);
            obj3 = khiva.Array(result);
        end
        
        function a = as(obj, dtype)
            %% AS
            % Casting the array to the given *dtype*.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libkhivac', 'khiva_as', ...
                obj.arrReference, int32(dtype), result);
            a = khiva.Array(result);
        end
    end
end

