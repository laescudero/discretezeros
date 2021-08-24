function out = expZerosNZM(FOne,dFone,a,b,c,d,sigma)
%expZerosNZM  Computes the expected number of zeros of Eq. (2.9) in the region [a,b] x [c,d] when the deterministic signal is FOne.
%
%   Usage:  out = expZerosNZM(FOne,dFone,a,b,c,d,sigma)
%           out = expZerosNZM(FOne,dFone,a,b,c,d)
%
%   Input:
%   FOne        :   the function denoted as F^1 in (2.9).
%   dFone       :   the (complex) derivative of the function denoted as F^1 in (2.9).
%   a,b,c,d     :   limits of the rectangle [a,b] x [c,d] in which the expectation is computed via numerical integration.
%   sigma       :   the standard deviation of the noise. (Default value: 1)
%
%   Output:
%   out         :   the expected number of zeros of (2.9) computed as indicated in Proposition (3.4).
%
%---------------------------------------------------------  

if ~exist('sigma','var')
    sigma = 1;
end

firstInt        = @(x,y) (1/(pi)) .* exp( - (1 ./ (sigma.^2)) .* abs(FOne(x + 1i .* y) .* exp(- (abs(x + 1i.*y).^2)./2) ).^2) .* (1 + ( exp(-abs(x+1i.*y).^2) ./ sigma.^2 ) .* (abs(dFone(x + 1i.*y) - (x - 1i.*y) .* FOne(x + 1i.*y))).^2);
out             = integral2(firstInt, a,b,c,d,'AbsTol',1e-10);
