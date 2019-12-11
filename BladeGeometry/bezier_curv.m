 function [C,curv] = bezier_curv(varargin)

    % ========================================================================================
    % Generates Bezier curve of order nb for np control points
    %
    % Implementation of Bezier curve follows description on
    % www.mathworld.wolfram.com/BezierCurve.html
    %
    % July 13, 2012
    %
    % ========================================================================================
    % Created by:  A. Peters
    % Modified by:
    % ----------------------------------------------------------------------------------------
    %
    % Inputs:
    % 1) P       = Control points
    % 2) bez_res = Bezier curve resolution 
    %
    % Outputs:
    % 1) C       = Bezier curve using conventional algorithm, matrix (length(t),2)
    % 2) Ccast   = Bezier curve using De Casteljau's algorithm, matrix (length(t),2)
    %              (increased numerical stability but higher computational cost)
    % 3) np      = Number of control points  (equal to order of Bernstein polynomial)
    %
    % ========================================================================================

    % ========================================================================================
    % Initialize variables
    % ========================================================================================

    P       = varargin{1};
    bez_res = varargin{2};

    np = length(P);                 % number of control points
    nb = np;                        % order of Bernstein polynomial used to compute
                                    % Bezier curve (equal to number of control points)

    t = linspace(0,1,bez_res);      % curve discretization

    if nargin == 2

        nCk = zeros(nb,nb);             % binomial coefficient
        B   = cell(nb,nb);              % Bernstein polynomial
        Cj  = zeros(nb,bez_res,2);      % Bezier curve up to control point j of np
        Ccast  = zeros(nb,bez_res,2);   % Bezier curve up to control point j of np

        nCk1 = zeros(nb - 1,nb - 1);    % binomial coefficient for first derivative
        B1   = cell(nb - 1,nb - 1);     % Bernstein polynomial for first derivative
        Cj1  = zeros(nb - 1,bez_res,2); % first derivative of Bezier curve up to control point j of np

        nCk2 = zeros(nb - 2,nb - 2);    % binomial coefficient for second derivative
        B2   = cell(nb - 2,nb - 2);     % Bernstein polynomial for second derivative
        Cj2  = zeros(nb - 2,bez_res,2); % second derivative of Bezier curve up to control point j of np

        curv = zeros(bez_res,1);        % curvature along Bezier curve

        % ========================================================================================
        % Compute Bezier curve using conventional algorithm
        % ========================================================================================

        for n = 1:nb        % indices from 1 to nb instead of 0 to nb - 1
            for j = 1:n
                nCk(n,j)    = factorial(n - 1)/(factorial(n - 1 - (j - 1))*factorial(j - 1));
                B{j,n}(:,1) = nCk(n,j).*t.^(j - 1).*(1 - t).^(n - 1 - (j - 1));               
            end    
        end
        for j = 1:np
            Cj(j,:,1)         = P(j,1).*B{j,np}(:,1);
            Cj(j,:,2)         = P(j,2).*B{j,np}(:,1);
        end

        C(:,1) = (sum(Cj(:,:,1),1))';
        C(:,2) = (sum(Cj(:,:,2),1))';

        % first derivative
        for n = 1:nb - 1        % indices from 1 to nb instead of 0 to nb - 3
            for j = 1:n
                nCk1(n,j)    = factorial(n - 1)/(factorial(n - 1 - (j - 1))*factorial(j - 1));
                B1{j,n}(:,1) = nCk1(n,j).*t.^(j - 1).*(1 - t).^(n - 1 - (j - 1));               
            end    
        end
        for j = 1:np - 1
            Cj1(j,:,1)         = (P(j + 1,1) - P(j,1)).*B1{j,np - 1}(:,1);
            Cj1(j,:,2)         = (P(j + 1,2) - P(j,2)).*B1{j,np - 1}(:,1);
        end

        C1(:,1) = np*(sum(Cj1(:,:,1),1))';
        C1(:,2) = np*(sum(Cj1(:,:,2),1))';

        % second derivative
        for n = 1:nb - 2        % indices from 1 to nb instead of 0 to nb - 3
            for j = 1:n
                nCk2(n,j)    = factorial(n - 1)/(factorial(n - 1 - (j - 1))*factorial(j - 1));
                B2{j,n}(:,1) = nCk2(n,j).*t.^(j - 1).*(1 - t).^(n - 1 - (j - 1));               
            end    
        end
        for j = 1:np - 2
            Cj2(j,:,1)         = (P(j + 2,1) - P(j + 1,1) + P(j,1)).*B2{j,np - 2}(:,1);
            Cj2(j,:,2)         = (P(j + 2,2) - P(j + 1,2) + P(j,2)).*B2{j,np - 2}(:,1);
        end

        C2(:,1) = np*(np - 1)*(sum(Cj2(:,:,1),1))';
        C2(:,2) = np*(np - 1)*(sum(Cj2(:,:,2),1))';

        curv(:,1) = (C1(:,1).*C2(:,2) - C1(:,2).*C2(:,1))./((C1(:,1).^2 + C1(:,2).^2).^(3/2));

    end
    
    % ========================================================================================
    % Alternatively use De Casteljau's algorithm to increase numerical stability at high orders
    % ========================================================================================

    if nargin ~= 2
        for j = 1:np	
            [p_bez] = CASTELJAU(t(1),t(end),P(1:j,1:2),t);
            Ccast(j,:,1:2) = p_bez(:,1:2);
        end
    end

    % ========================================================================================
 end