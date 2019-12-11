function [val] = CASTELJAU(a,b,p,y)

    % ========================================================================================
    % Generates Bezier curve of order nb for np control points
    %
    % Implementation of Bezier curve follows description on
    % www.mathworld.wolfram.com/BezierCurve.html
    %
    % July 13, 2012
    %
    % ========================================================================================
    % Created by:  Jonas Ballani, University of Stuttgart (2007)
    % Modified by:
    % ----------------------------------------------------------------------------------------
    %
    % Inputs:
    % 1) a       = starting point of interval t
    % 2) b       = end point of interval t
    % 3) p       = control points
    % 4) y       = interval vector t
    %
    % Outputs:
    % 1) val     = Bezier curve using De Casteljau's algorithm, matrix (length(t),2)
    %              (increased numerical stability but higher computational cost)
    %
    % ========================================================================================

    n = size(p,1);
    m = length(y);
    val = zeros(m,2);
    X(:,1) = p(:,1);
    Y(:,1) = p(:,2);

    for j = 1:m
        for i = 2:n
            X(i:n,i) = (b-y(j))/(b-a)*X(i-1:n-1,i-1) + (y(j)-a)/(b-a)*X(i:n,i-1);
            Y(i:n,i) = (b-y(j))/(b-a)*Y(i-1:n-1,i-1) + (y(j)-a)/(b-a)*Y(i:n,i-1);
        end
        val(j,1) = X(n,n);
        val(j,2) = Y(n,n);
    end
end