classdef Dtype < int32
    %% DTYPE
    % Khiva array available types.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Shapelets.io
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    enumeration
        f32 (0)
        % Float. khiva.dtype
        c32 (1)
        % 32 bits Complex. khiva.dtype
        f64 (2)
        % 64 bits Double. khiva.dtype
        c64 (3)
        % 64 bits Complex. khiva.dtype
        b8 (4)
        % Boolean. khiva.dtype
        s32 (5)
        % 32 bits Int. khiva.dtype
        u32 (6)
        % 32 bits Unsigned Int. khiva.dtype
        u8 (7)
        % 8 bits Unsigned Int. khiva.dtype
        s64 (8)
        % 64 bits Integer. khiva.dtype
        u64 (9)
        % 64 bits Unsigned Int. khiva.dtype
        s16 (10)
        % 16 bits Int. khiva.dtype
        u16 (11)
        % 16 bits Unsigned int. khiva.dtype
    end
    methods(Static)
        function dtype = fromVariableClass(var)
            %% FROMVARIABLECLASS
            % This function determines the enumerate value
            % of Dtype from the class of the input variable 'var'.
            %
            % *var* A Matlab variable.
            
            % Checking if it is a complex number
            isReal = isreal(var);
            clazz = class(var);
            if isReal
                switch clazz
                    case 'single'
                        dtype = khiva.Dtype.f32;
                    case 'double'
                        dtype = khiva.Dtype.f64;
                    case 'logical'
                        dtype = khiva.Dtype.b8;
                    case 'int32'
                        dtype = khiva.Dtype.s32;
                    case 'uint32'
                        dtype = khiva.Dtype.u32;
                    case 'uint8'
                        dtype = khiva.Dtype.u8;
                    case 'int64'
                        dtype = khiva.Dtype.s64;
                    case 'uint64'
                        dtype = khiva.Dtype.u64;
                    case 'int16'
                        dtype = khiva.Dtype.s16;
                    case 'uint16'
                        dtype = khiva.Dtype.u16;
                    otherwise
                        fprintf('Error, %s data type not supported.', clazz)
                        exit(-1)
                        
                end
            else
                switch clazz
                    case 'single'
                        dtype = khiva.Dtype.c32;
                    case 'double'
                        dtype = khiva.Dtype.c64;
                    otherwise
                        fprintf('Error, only complex numbers of single and double precision floating points allowed.')
                        exit(-1)
                end
            end
        end
        
        function clazz = toClass(dtype)
            %% TOCLASS
            % This function determines the Matlab class of the given
            % enumerate value of Khiva Dtype'.
            %
            % *dtype* Instance of the Dtype enumeratie of Khiva.
            switch int32(dtype)
                case int32(khiva.Dtype.f32)
                    clazz = 'single';
                case int32(khiva.Dtype.c32)
                    clazz = 'single';
                case int32(khiva.Dtype.f64)
                    clazz = 'double';
                case int32(khiva.Dtype.c64)
                    clazz = 'double';
                case int32(khiva.Dtype.b8)
                    clazz = 'logical';
                case int32(khiva.Dtype.s32)
                    clazz = 'int32';
                case int32(khiva.Dtype.u32)
                    clazz = 'uint32';
                case int32(khiva.Dtype.u8)
                    clazz = 'uint8';
                case int32(khiva.Dtype.s64)
                    clazz = 'int64';
                case int32(khiva.Dtype.u64)
                    clazz = 'uint64';
                case int32(khiva.Dtype.s16)
                    clazz = 'int16';
                case int32(khiva.Dtype.u16)
                    clazz = 'uint16';
                otherwise
                    fprintf('Error, %s data type not supported.', dtype)
                    exit(-1)
            end
        end
    end
end

