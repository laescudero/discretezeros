function [answerX, answerY, matrixResult] = AMN(GAFExp, delta_GAF, zReal, zImag, separation)
%AMN  Obtain numerical zeros via AMN.
%
%   Usage:  [answerX, answerY, matrixResult] = AMN(GAFExp, delta_GAF, zReal, zImag)
%           [answerX, answerY, matrixResult] = AMN(GAFExp, delta_GAF, zReal, zImag, separation)
%
%   Input:
%
%   GAFExp          :   a matrix that contains the samples of a random entire function as in Eq. (2.9).
%   delta_GAF       :   the increment in the imaginary/real coordinates used when sampling GAFExp.
%   zReal           :   an array containing the real coordinates to interpret GAFExp in the complex plane.
%   zImag           :   an array containing the imaginary coordinates to interpret GAFExp in the complex plane.
%   separation      :   an integer indicating the distance applied in the sieving step. (Optional. Default value: 5)
%
%   Output:
%   answerX         :   an array containing the first coordinate of the numerical zeros.
%   answerY         :   an array containing the second coordinate of the numerical zeros.
%   matrixResult    :   an array containing the coordinates of the zeros in linear indexing.
%
%---------------------------------------------------------

if ~exist('separation','var')
    separation = 5;
end

% We compute the threshold Eq. (2.6).
tau_lambda                          = abs( exp(0.5 * delta_GAF .* (2 * 1i .* bsxfun(@plus, zImag(1:end-1),  0.*zReal(1:end-1)') + delta_GAF) ) .* GAFExp(2:end, 1:end-1) - GAFExp(1:end-1, 1:end-1)); 
threshold                           = max(3/4 .* tau_lambda,  abs(GAFExp(1:end-1, 1:end-1)));

% The threshold can only be computed for coordinates at distance delta from the boundary.
% We extend it to have the same size as the matrix GAFExp.

zeros_row            = zeros(size(threshold,2),1);
thresholdExtension_1 = [threshold; zeros_row'];
zeros_column         = zeros(size(thresholdExtension_1, 1),1);
thresholdExtension   = [thresholdExtension_1, zeros_column];
clear thresholdExtension_1 threshold
        
        
rowsNumber          =   size(GAFExp,1);
columnsNumber       =   size(GAFExp,2);

% We set the shifts to compare a selected point ('X') with its distanceDelta-delta ('A') neighbors. 
% If distanceDelta=2 then we obtain the coordinates for the points marked as 'A'.
%
% A A A A A
% A - - - A
% A - X - A
% A - - - A
% A A A A A

distanceDelta = 2;
shifts = shiftsGrid(distanceDelta);

% We select points satisfying Eq. (2.7).
% We use linear indexing to make the comparison with the other neighboring bins.
% Here we apply the selection step of the algorithm AMN presented in our paper.

[rowsInitialSet, columnsInitialSet]     =   find( abs(GAFExp(distanceDelta+1:rowsNumber-distanceDelta, distanceDelta+1:columnsNumber-distanceDelta)) ...
                                                    + thresholdExtension(distanceDelta+1:rowsNumber-distanceDelta, distanceDelta+1:columnsNumber-distanceDelta) ...
                                                        <= abs( GAFExp(distanceDelta+1+shifts(1,1):rowsNumber-distanceDelta+shifts(1,1), distanceDelta+1+shifts(1,2):columnsNumber-distanceDelta+shifts(1,2))));
matrixResult                            =   sub2ind([size(GAFExp,1), size(GAFExp,2)], distanceDelta+rowsInitialSet, distanceDelta+columnsInitialSet);

for j=2:size(shifts, 1)
    matrixResult                        =   matrixResult(abs(GAFExp(matrixResult)) + thresholdExtension(matrixResult) <= abs( GAFExp(matrixResult+shifts(j,1)+shifts(j,2)*rowsNumber)) );
end

% Here we apply the sieving step and convert the linear indexing into subscripts.
% The sieving step here used is denoted as S1 in the paper.

[answerX, answerY, matrixResult]        = sievingStepOrd(GAFExp, matrixResult, separation);

% The previous line could be commented and replaced by the one below:
% [answerX, answerY, matrixResult]        = sievingStepNonOrd(GAFExp, matrixResult, separation);
% This would replace the ordered sieving denoted as Algorithm S1 in our manuscript by one that omits the Step 2 and 3 therein defined.
