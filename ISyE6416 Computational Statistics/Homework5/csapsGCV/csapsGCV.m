function [v,p,V,VAR,CI] = csapsGCV(x,y,p,xx,W)
% Written by Matthew Taliaferro
%    The function outputs the values from the spline interpolation, v, the
% value of the smoothing paramter, p, the value of the generalized
% cross-validation minimization function, V, the estimated variance, VAR,
% and the 95% confidence interval, CI. If xx is no specified, v is
% calculated at x.
%    The function accepts x and y as input vectors, the smoothing
% parameter (p), evaluation coordinates (xx), and weights (W) are optional.
% If the smoothing parameter is not specified, it if found using
% generalized cross-validation if length(x) > 30 and ordinary
% cross-validation otherwise. If xx is unspecified the function is
% evaluated at x. If weights are unspecified, they are set to 1. The
% weights are assumed to be a vector of the standard deviations associated
% with the oberserved variables.
%    Generally, the function gets an initial guess by sampling various
% values of p, from 1e-4, 1e-3, ..., 1e10. The first local maximum is used
% as the initial guess for use with fminsearch. If the number of points is
% less than 30, "ordinary" cross validation is used, otherwise generalized
% cross-validation is used. After estimating the optimal smoothing paramter
% the estimated variance and 95% confidence intervals are calculated.
%    This function does not make use of ppval, rather it calculates the
% spline the way Reinsch specified. Outside the range of x, the values are
% estimated using a linear fit.
% 
%    The definition of p used by csaps and this funciton a are different.
% The smoothing parameter using generalized cross validation ,p, from
% Wahba:
% 
% p * sum_j |(Y(:,j) - f(X(j)))/W(j)|^2  +  integral |D^2 f|^2
% 
% is equivalent to pcsaps/(1-pcsaps).
% 
%    Note the weights are also different than what csaps expects. Instead
% of the inverse of the variance, this function assumes the weights are the
% standard deviations associated with the observed variables.
%
% Written by Matthew Taliaferro
% 
% References:
% 
% Craven, Peter, and Grace Wahba. "Smoothing noisy data with spline
%  functions." Numerische Mathematik 31.4 (1978): 377-403.
% 
% Hutchinson, Michael F., and F. R. De Hoog. "Smoothing noisy data with
%  spline functions." Numerische mathematik 47.1 (1985): 99-106.
% 
% Reinsch, Christian H. "Smoothing by spline functions."
%  Numerische mathematik 10.3 (1967): 177-183.
% 
% Wahba, Grace. "Bayesian" confidence intervals" for the cross-validated
%  smoothing spline." Journal of the Royal Statistical Society. Series B
%  (Methodological) (1983): 133-150.
%
% Wahba, Grace. Spline models for observational data. Society for
%  industrial and applied mathematics, 1990. Chapter 4 and 5.

N = length(x);
if nargin < 5, W = []; end

% Vectors need to be same length
sizey = size(y); sizex = size(x); sizeW = size(W);
if numel(x) ~= numel(y), error('x and y are not the same size'); end
if (numel(x) ~= numel(W))&&(~isempty(W)), error('x and W are not the same size'); end
if numel(y) > max(sizey), error('y needs to be a vector'); end
% Vectors need to be column vectors
if sizex(2) > 1, x = x'; end
if sizey(2) > 1, y = y'; end
if sizeW(2) > 1, W = W'; end

% Sort vectors so x(1)<x(2)<...<x(i)<...<x(N)
if ~issorted(x)
    [x_sorted,ii_sort] = sort(x);
    y = y(ii_sort);
else
    x_sorted = x;
end
if (nargin < 5)||(isempty(W))
    W = diag(ones(N,1));
else
    W = diag(W(ii_sort));
end

% Normalize the x vector
t = (x_sorted-min(x))/(max(x)-min(x));
h = diff(t);
if (nargin < 4)||(isempty(xx))
    tt = (x-min(x))/(max(x)-min(x));
else
    tt = (xx-min(x))/(max(x)-min(x));
end

% Get initial guess
P = logspace(-4,10,15);
V = 0*P;
for ii = 1:length(P)
    V(ii) = GCV(y,h,P(ii),N,W);
end
% The location of the first peak for -V is the initial guess for p. If it
% does not exist, the minimum location for V is used instead.
try
    [~,iiV] = findpeaks(-V);
    iiV = iiV(1);
catch
    [~,iiV] = min(V);
end

% Estimate optimal value of smoothing parameter
if (nargin < 3)||(isempty(p))
    options = optimset('TolFun',(1e-3)*V(iiV),'TolX',(1e-3)*P(iiV));
    if N > 30
        p = fminsearch(@(p) GCV(y,h,p,N,W),P(iiV),options);
    else
        p = fminsearch(@(p) OCV(y,t,p,N,diag(W)),P(iiV),options);
    end
end
if p < 0
    warning('smoothing parameter is less than 0, estimating value at 1e-4')
    p = 1e-4;
end

% Estimate variance and 95% confidence interval
[V,VAR,CI] = GCV(y,h,p,N,W);

% Calculate values for xx (or x)
coeffs = calc_coeffs(y,h,p,N,W);
v = calc_spline(tt,t,coeffs);

end

function y = calc_spline(tt,t,coeffs)
y = 0*tt;
for jj = 1:length(tt)
    index = sum(tt(jj) >= t);
    if tt(jj) <= 0
        %y(jj) = coeffs(1,end); % zeroth order extrapolation
        y(jj) = polyval(coeffs(1,end-1:end),tt(jj)); % linear extrapolation
    elseif tt(jj) >= 1
        %y(jj) = coeffs(end,end);   % zeroth order extrapolation
        y(jj) = polyval(coeffs(end,end-1:end),tt(jj)-t(end)); % linear extrapolation
    elseif tt(jj) == t(index)
        y(jj) = coeffs(index,4);    % the smoothing value at the observed points is expected value at that point
    else
        y(jj) = polyval(coeffs(index,:),tt(jj)-t(index));
    end
end
end

function coeffs = calc_coeffs(y,h,p,N,W)
% from Reinsch
Q = return_differences(h,N);
T = return_T(h);
B = calc_B(Q,W,p,T);

c = B\(p*Q'*y);
a = y-(((W^2)*Q)*c)/p;

c = [0;c;0];
d = (c(2:end)-c(1:end-1))./(3*h);
d = [d;d(end)];
b = (a(2:end)-a(1:end-1))./h-c(1:end-1).*h-d(1:end-1).*(h.^2);
b = [b;b(end)];

coeffs = [d,c,b,a];
end

function [V,VAR,CI] = GCV(y,h,p,N,W)
% Generalized cross-validation
Q = return_differences(h,N);
T = return_T(h);
B = calc_B(Q,W,p,T);

tr = N-2-p*trace(T/B);  % the estimated degrees of freedom
error = ((((W^2)*Q)/B)*Q')*y;
RSS = (error./diag(W))'*(error./diag(W));   % weighted residual sum of squares
V = N*RSS/(tr^2);

if nargout > 1
    A = calc_influence(h,p,N,W);
    RSS = error'*error;
    VAR = RSS/tr;
    CI = 1.96*sqrt(VAR*diag(A));
end

end

function [V,VAR,CI] = OCV(y,t,p,N,W)
% "Ordinary" cross-validation
C = cvpartition(length(t),'LeaveOut');

SSE = 0;

% Cycle through points
for jj = 1:N;
    % Remove data point(s)
    tCV = t(C.training(jj));
    yCV = y(C.training(jj));
    wCV = W(C.training(jj));
    N = C.TrainSize(jj);
    
    % fit data
    h = diff(tCV);
    coeffs = calc_coeffs(yCV,h,p,N,diag(wCV));
    
    % Calculate sum of square errors of with held data points
    SSE = SSE+sum(((y(C.test(jj))-calc_spline(t(C.test(jj)),tCV,coeffs))./wCV).^2);
end

% Calculate Mean Square Error for model
V = SSE;

if nargout > 1
    [~,VAR,CI] = GCV(y,diff(t),p,N,diag(W));
end

end

function A = calc_influence(h,p,N,W)
% Influence (or hat) matrix
Q = return_differences(h,N);
T = return_T(h);
B = calc_B(Q,W,p,T);

I = eye(N);
A = I-(((W^2)*Q)/B)*Q';
end

function B = calc_B(Q,W,p,T)

B = (Q'*(W^2))*Q+p*T;
end

function Q = return_differences(h,N)
% The difference matrix, Q in both Reinsch, 1967, pg 179 and Craven and
% Wahba, 1979, eq 5.1. It is denoted as G in Hutchinson and de Hoog, 1985.
% Note there is an error in Craven and Wahba, used definition from Reinsch.

%Q = diag(1./h(2:end-1),-1)+diag(-1./h(1:end-1)-1./h(2:end),0)+diag(1./h(2:end-1),1);
%Q = padarray(Q,[2,0],'post');
Q = zeros(N,N-2);
Q(1:N+1:N*(N-2)) = 1./h(1:end-1);
Q(2:N+1:N*(N-2)) = -1./h(1:end-1)-1./h(2:end);
Q(3:N+1:N*(N-2)) = 1./h(2:end);
end


function T = return_T(h)
% The difference matrix, T in both Reinsch, 1967, pg 179 and Craven and
% Wahba, 1979, eq 5.1. It is denoted as H in Hutchinson and de Hoog, 1985.

T = (diag(h(2:end-1),-1)+diag(2*(h(1:end-1)+h(2:end)),0)+diag(h(2:end-1),1))/3;
end