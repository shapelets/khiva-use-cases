classdef Library < handle
    %% LIBRARY Class
    % Class to change internal properties of the TSA library.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Grumpy Cat Software S.L.
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
                addpath(fullfile('/usr/local/include','tsa_c'))
                libraryPath = '/usr/local/lib/libtsa_c.dylib';
                includePath = '/usr/local/include';
            elseif isunix
                addpath(fullfile('/usr/local/include','tsa_c'))
                libraryPath = '/usr/local/lib/libtsa_c.so';
                includePath = '/usr/local/include';
            elseif ispc
                addpath(fullfile('C:/Program Files/TSA/include','tsa_c'))
                libraryPath = 'C:/Program Files/TSA/lib/tsa_c.dll';
                includePath = 'C:/Program Files/TSA/include';                         
            else
                disp('Platform not supported')
            end

            if libisloaded('libtsac')
                unloadlibrary('libtsac')
            end
            
            [~, ~] = loadlibrary(libraryPath, ...
                strcat(includePath,'/tsa_c.h'), ...
                'addheader','tsa_c/array.h', ...
                'addheader','tsa_c/dimensionality.h', ...
                'addheader','tsa_c/distances.h', ...
                'addheader','tsa_c/features.h', ...
                'addheader','tsa_c/library.h', ...
                'addheader','tsa_c/linalg.h', ...
                'addheader','tsa_c/matrix.h', ...
                'addheader','tsa_c/normalization.h', ...
                'addheader','tsa_c/polynomial.h', ...
                'addheader','tsa_c/regression.h', ...
                'addheader','tsa_c/regularization.h', ...
                'addheader','tsa_c/statistics.h', ...
                'includepath',includePath,'alias','libtsac');
            
        end
    end
    
    methods(Static)
        function obj = instance()
            %% LIBRARY
            % Creates an instance of the library class, loading the
            % shared library.
            persistent uniqueInstance
            if isempty(uniqueInstance)
                obj = tsa.Library();
                uniqueInstance = obj;
            else
                obj = uniqueInstance;
            end
        end
        
        function info()
            %% INFO
            % Get the devices info.
            calllib('libtsac','info')
        end
        
        function backend = getBackend()
            %% GETBACKEND
            % Get the active backend.
            % Returns an instance of the Backend enumeration class.
            b = int32(0);
            b = calllib('libtsac','get_backend',b);
            backend = tsa.Backend(b);
        end
        
        function backends = getBackends()
            %% GETBACKENDS
            % Get the available backends.
            backends = int32(0);
            backends = calllib('libtsac','get_backends',backends);
        end
        
        function deviceCount = getDeviceCount()
            %% GETDEVICECOUNT
            % Get the available number of devices for the current backend.
            deviceCount = int32(0);
            deviceCount = calllib('libtsac','get_device_count',deviceCount);
        end
        
        function deviceId = getDeviceId()
            %% GETDEVICEID
            % Get the active device.
            deviceId = int32(0);
            deviceId = calllib('libtsac','get_device_id',deviceId);
        end
        
        function setDevice(device)
            %% SETDEVICE
            % Set the device.
            calllib('libtsac','set_device',device)
        end
        
        function setBackend(backend)
            %% SETBACKEND
            % Set the Backend.
            % 
            % *backend* should be an instance of the Backend enumeration
            % class.
            calllib('libtsac','set_backend',int32(backend))
        end
        
        function v = version()
            %% VERSION
            % Returns a string with the current version of the library.
            v = {blanks(40)};
            v = calllib('libtsac','version',v);
            v = cell2mat(v);
        end
    end
end

