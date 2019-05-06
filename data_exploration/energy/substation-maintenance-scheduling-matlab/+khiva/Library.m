classdef Library < handle
    %% LIBRARY Class
    % Class to change internal properties of the Khiva library.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Shapelets.io
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    methods(Access=private)
        % Guard the constructor against external invocation.  We only want
        % to allow a single instance of this class.
        function newObj = Library()
            libraryPath = '';
            includePath = '';

            if ismac
                addpath(fullfile('/usr/local/include','khiva_c'))
                libraryPath = '/usr/local/lib/libkhiva_c.dylib';
                includePath = '/usr/local/include';
            elseif isunix
                addpath(fullfile('/usr/local/include','khiva_c'))
                libraryPath = '/usr/local/lib/libkhiva_c.so';
                includePath = '/usr/local/include';
            elseif ispc
                addpath(fullfile('C:/Program Files/Khiva/v0/include','khiva_c'))
                libraryPath = 'C:/Program Files/Khiva/v0/lib/khiva_c.dll';
                includePath = 'C:/Program Files/Khiva/v0/include';                         
            else
                disp('Platform not supported')
            end

            if libisloaded('libkhivac')
                unloadlibrary('libkhivac')
            end
            
            [~, ~] = loadlibrary(libraryPath, ...
                strcat(includePath,'/khiva_c.h'), ...
                'addheader','khiva_c/array.h', ...
                'addheader','khiva_c/dimensionality.h', ...
                'addheader','khiva_c/distances.h', ...
                'addheader','khiva_c/features.h', ...
                'addheader','khiva_c/library.h', ...
                'addheader','khiva_c/linalg.h', ...
                'addheader','khiva_c/matrix.h', ...
                'addheader','khiva_c/normalization.h', ...
                'addheader','khiva_c/polynomial.h', ...
                'addheader','khiva_c/regression.h', ...
                'addheader','khiva_c/regularization.h', ...
                'addheader','khiva_c/statistics.h', ...
                'includepath',includePath,'alias','libkhivac');
            
        end
    end
    
    methods(Static)
        function obj = instance()
            %% LIBRARY
            % Creates an instance of the library class, loading the
            % shared library.
            persistent uniqueInstance
            if isempty(uniqueInstance)
                obj = khiva.Library();
                uniqueInstance = obj;
            else
                obj = uniqueInstance;
            end
        end
        
        function info()
            %% INFO
            % Get the devices info.
            calllib('libkhivac','info')
        end
        
        function backend = getBackend()
            %% GETBACKEND
            % Get the active backend.
            % Returns an instance of the Backend enumeration class.
            b = int32(0);
            b = calllib('libkhivac','get_backend',b);
            backend = khiva.Backend(b);
        end
        
        function backends = getBackends()
            %% GETBACKENDS
            % Get the available backends.
            backends = int32(0);
            backends = calllib('libkhivac','get_backends',backends);
        end
        
        function deviceCount = getDeviceCount()
            %% GETDEVICECOUNT
            % Get the available number of devices for the current backend.
            deviceCount = int32(0);
            deviceCount = calllib('libkhivac','get_device_count',deviceCount);
        end
        
        function deviceId = getDeviceId()
            %% GETDEVICEID
            % Get the active device.
            deviceId = int32(0);
            deviceId = calllib('libkhivac','get_device_id',deviceId);
        end
        
        function setDevice(device)
            %% SETDEVICE
            % Set the device.
            calllib('libkhivac','set_device',device)
        end
        
        function setBackend(backend)
            %% SETBACKEND
            % Set the Backend.
            % 
            % *backend* should be an instance of the Backend enumeration
            % class.
            calllib('libkhivac','set_backend',int32(backend))
        end
        
        function v = version()
            %% VERSION
            % Returns a string with the current version of the library.
            v = {blanks(40)};
            v = calllib('libkhivac','version',v);
            v = cell2mat(v);
        end
    end
end

