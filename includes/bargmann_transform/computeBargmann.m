function [GAFExp, zReal, zImag] = computeBargmann(f, deltaSpacing, T, L)
%computeBargmann  Sample the Bargmann transform in a uniformly spaced grid of [-L,L]^2.
%                 This function implements the estimation proposed in Eq (5.3).
%   Usage:  [GAFExp, zReal, zImag] = computeBargmann(f, deltaSpacing, T, L)
%
%   Input:
%
%   f               :   samples of a function in an interval [-T-L, T+L] spaced by deltaSpacing.
%   deltaSpacing    :   samples spacing of the input function and the resulting grid.
%   T               :   a number specifying the effective support of the Gaussian window.
%   L               :   a number that defines the region in which the Bargmann transform is sampled.
%
%   Output:
%   GAFExp          :   a matrix that estimates samples of the Bargmann transform of f in a grid of [-L,L]^2 with a deltaSpacing-spacing.
%   zReal           :   the real coordinates associated with the rows of GAFExp.
%   zImag           :   the imaginary coordinates associated with the columns of GAFExp.
%
%---------------------------------------------------------

% We sample the Gaussian window in [-T, T].
H_w                                             = [-T:deltaSpacing:T].';
window                                          = sqrt(2/pi) .* exp(- (H_w.^2));

sigLength                                       = length(f)-length(window);
zReal                                           = ((0:sigLength-1)*deltaSpacing-L);
zImag                                           = zReal;
GAFExp                                          = zeros(sigLength, sigLength);
centeredcoordinates                             = @(k) (1:length(window)) + k;
indices                                         = (1:length(window));

for indexRows = 0:sigLength-1
  % Progress bar
  if ~(exist('p','var'))
    p=floor(100*(indexRows+1)/sigLength);
    S=sprintf('%g%%', p);
    fprintf('%s', S);
  elseif ~(floor(100*(indexRows+1)/sigLength) == p)
    fprintf(repmat('\b',1,numel(S))); 
    p=floor(100*(indexRows+1)/sigLength);
    S=sprintf('%g%%', p);
    fprintf('%s', S);
  end
 
  restricted_f_to_transform                   = zeros(1, sigLength);
  % We compute the product between the function and the shifted window.
  restricted_f_to_transform(indices)          = f(centeredcoordinates(indexRows+1)) .* window  .* exp(2 .* 1i .* L .* (indices-1).' .* deltaSpacing );
  % We apply the discrete Fractional Fourier Transform to effectively compute Eq. (5.1).
  res                                         = (ffft(restricted_f_to_transform, (deltaSpacing^2)/pi )) ;
  % We correct the phase as indicated in Eq (5.3). 
  % We also flip the vector to obtain the result corresponding to z conjugated.
  GAFExp(indexRows+1, :)                      =  (exp(-1i .* zReal(indexRows+1) .* zImag )) .* fliplr( exp( -2 .* 1i .* ( (-T-L + indexRows .* deltaSpacing) .* ( (0:sigLength-1) .* deltaSpacing - L ) ) ) .* res);
  if (indexRows == sigLength-1)
    fprintf('\n')
  end
end