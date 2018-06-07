classdef Linalg < handle
    %% LINALG class
    % Khiva Linear Algebra class containing linear algebra methods.
    
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
        %function lls = lls(a, b)
        %   %% LLS
        %   % Calculates the minimum norm least squares solution $x$
        %   % $(\left\lVert{A·x − b}\right\rVert^2)$ to $A·x = b$. This
        %   % function uses the singular value decomposition function of
        %   % Arrayfire. The actual formula that this function computes is
        %   % $x = V·D\dagger·U^T·b$. Where $U$ and $V$ are orthogonal
        %   % matrices and $D\dagger$ contains the inverse values of the
        %   % singular values contained in D if they are not zero, and zero
        %   % otherwise.
        %   % 
        %   % *a* A Khiva array pointing to acoefficient matrix containing
        %   % the coefficients of the linear equation problem to solve.
        %   %
        %   % *b* A Khiva array pointing to a vector with the measured values.
        %   result = libpointer('voidPtrPtr');
        %   [~, ~, result] = calllib('libkhivac', 'lls', ...
        %       a.getReference(), b.getReference(), result);
        %   lls = khiva.Array(result);
        %end
    end
end