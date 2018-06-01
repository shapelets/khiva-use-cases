classdef Dimensionality < handle
    %% DIMENSIONALITY class
    % TSA Dimensionality class containing different dimensionality
    % reduction methods.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Grumpy Cat Software S.L.
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    methods(Static)
        function rdp = ramerDouglasPeucker(array, epsilon)
            %% RAMERDOUGLASPEUCKER
            % The Ramer–Douglas–Peucker algorithm (RDP) is an algorithm for
            % reducing the number of points in a curve that is approximated
            % by a series of points. It reduces a set of points depending
            % on the perpendicular distance of the points and epsilon, the
            % greater epsilon, more points are deleted.
            %
            % [1] Urs Ramer, "An iterative procedure for the polygonal
            % approximation of plane curves", Computer Graphics and Image
            % Processing, 1(3), 244–256 (1972)
            % doi:10.1016/S0146-664X(72)80017-0.
            %
            % [2] David Douglas & Thomas Peucker, "Algorithms for the
            % reduction of the number of points required to represent a
            % digitized line or its caricature", The Canadian Cartographer
            % 10(2), 112–122 (1973) doi:10.3138/FM57-6770-U75U-7727
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array contains
            % the x-coordinates and y-coordinates of the input points
            % (x in column 0 and y in column 1).
            %
            % *epsilon* Minimum standard deviation to consider. It acts as
            % a gatekeeper for those time series that may be constant or
            % near constant.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libtsac', 'ramer_douglas_peucker', ...
                array.getReference(), epsilon, result);
            rdp = tsa.Array(result);
        end
        
        function v = visvalingam(array, numPoints)
            %% VISVALINGAM
            % Reduces a set of points by applying the Visvalingam method
            % (minimun triangle area) until the number of points is reduced
            % to numPoints.
            %
            % [1] M. Visvalingam and J. D. Whyatt, Line generalisation by
            % repeated elimination of points, The Cartographic Journal,
            % 1993.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array contains
            % the x-coordinates and y-coordinates of the input points
            % (x in column 0 and y in column 1).
            %
            % *numPoints* Sets the number of points returned after the
            % execution of the method.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libtsac', 'visvalingam', ...
                array.getReference(), numPoints, result);
            v = tsa.Array(result);
        end
        
        function p = paa(array, bins)
            %% PAA
            % Piecewise Aggregate Approximation (PAA) approximates a time
            % series $X$ of length $n$ into vector
            % $\bar{X}=(\bar{x}_{1},…,\bar{x}_{M})$ of any arbitrary length
            % $M \leq n$ where each of $\bar{x_{i}}$ is calculated as
            % follows:
            %
            % $$\bar{x}_{i} = \frac{M}{n} \sum_{j=n/M(i-1)+1}^{(n/M)i} x_{j}$$.
            %
            % Which simply means that in order to reduce the dimensionality
            % from $n$ to $M$, we first divide the original time series
            % into $M$ equally sized frames and secondly compute the mean
            % values for each frame. The sequence assembled from the mean
            % values is the PAA approximation (i.e., transform) of the
            % original time series.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple sets of points (one per column).
            %
            % *bins* Sets the total number of divisions.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libtsac', 'paa', ...
                array.getReference(), bins, result);
            p = tsa.Array(result);
        end
        
        function s = sax(array, alphabetSize)
            %% SAX
            % Symbolic Aggregate approXimation (SAX). It transforms a
            % numeric time series into a time series of symbols with the
            % same size. The algorithm was proposed by Lin et al.) and
            % extends the PAA-based approach inheriting the original
            % algorithm simplicity and low computational complexity while
            % providing satisfactory sensitivity and selectivity in range
            % query processing. Moreover, the use of a symbolic
            % representation opened a door to the existing wealth of
            % data-structures and string-manipulation algorithms in
            % computer science such as hashing, regular expression, pattern
            % matching, suffix trees, and grammatical inference.
            %
            % [1] Lin, J., Keogh, E., Lonardi, S. & Chiu, B. (2003) A
            % Symbolic Representation of Time Series, with Implications for
            % Streaming Algorithms. In proceedings of the 8th ACM SIGMOD
            % Workshop on Research Issues in Data Mining and Knowledge
            % Discovery. San Diego, CA. June 13.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *alphabetSize* Number of element within the alphabet.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libtsac', 'sax', ...
                array.getReference(), alphabetSize, result);
            s = tsa.Array(result);
        end
        
        function p = pip(array, numberIPs)
            %% PIP
            % Calculates the number of Perceptually Important Points (PIP)
            % in the time series.
            %
            % [1] Fu TC, Chung FL, Luk R, and Ng CM. Representing financial
            % time series based on data point importance. Engineering
            % Applications of Artificial Intelligence, 21(2):277-300, 2008.
            %
            % *array* is an instance of the TSA array class, which points
            % to an array stored in the device side. The array dimension
            % zero is the length of the time series.
            %
            % *numberIPs* The number of points to be returned.
            result = libpointer('voidPtrPtr');
            [~, ~, result] = calllib('libtsac', 'pip', ...
                array.getReference(), numberIPs, result);
            p = tsa.Array(result);
        end
    end
end