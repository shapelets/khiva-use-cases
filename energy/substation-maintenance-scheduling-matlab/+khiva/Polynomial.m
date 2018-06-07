classdef Polynomial < handle
    %% POLYNOMIAL class
    % Khiva Polynomial class containing a number of polynomial methods.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Shapelets.io
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    methods(Static)
        % Commented because this function fails just in Matlab. It is not
        % failing in python, neither in Java. It is failing when using the
        % lls solver of khiva which uses the svd function of ArrayFire. It
        % fails exactly at the point where svd is used.
        %function p = polyfit(x, y, deg)
        %    %% POLYFIT
        %    % Least squares polynomial fit. Fit a polynomial
        %    % $p(x) = p[0] * x^{deg} + ... + p[deg]$ of degree $deg$ to
        %    % points $(x, y)$. Returns a vector of coefficients $p$ that
        %    % minimises the squared error.
        %    %
        %    % *x* is an instance of the Khiva array class, which points to
        %    % the x-coordinates of the M sample points $(x[i], y[i])$.
        %    %
        %    % *y* is an instance of the Khiva array class, which points to
        %    % the y-coordinates of the sample points.
        %    %
        %    % *deg* Degree of the fitting polynomial.
        %    result = libpointer('voidPtrPtr');
        %    [~, ~, ~, result] = calllib('libkhivac', 'polyfit', ...
        %        x.getReference(), y.getReference(), deg, result);
        %    p = khiva.Array(result);
        %end
        
        function r = roots(p)
            %% ROOTS
            % Calculates the roots of a polynomial with coefficients given
            % in $p$. The values in the rank-1 array $p$ are coefficients
            % of a polynomial. If the length of $p$ is $n+1$ then the
            % polynomial is described by:
            % 
            % $$p[0]*x^n+p[1]*x^{n-1}+...+p[n-1]*x+p[n]$$
            %
            % *p* is an instance of the Khiva array class, which points to
            % the polynomial coefficients.
            result = libpointer('voidPtrPtr');
            [~, result] = calllib('libkhivac', 'roots', ...
                p.getReference(), result);
            r = khiva.Array(result);
        end
    end
end

