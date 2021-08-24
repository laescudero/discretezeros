function [answerX, answerY, matrixResult] = ST(GAFExp, threshold, separation)
%ST  Obtain numerical zeros via simple thresholding followed by the sieving ST1.
%
%   Usage:  [answerX, answerY, matrixResult] = ST(GAFExp, threshold, separation)
%
%   Input:
%
%   GAFExp          :   a matrix that contains the samples of a random entire function as in Eq. (2.9).
%   threshold       :   the applied threshold to estimate the zero set. (2 * \delta in our simulations)
%   separation      :   the separation applied in the sieving step. (Default value: 5 * \delta).
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

rowsNumber          =   size(GAFExp,1);
columnsNumber       =   size(GAFExp,2);

[rowsInitialSet, columnsInitialSet]     =   find(GAFExp <= threshold);
matrixResult                            =   sub2ind([size(GAFExp,1), size(GAFExp,2)],rowsInitialSet, columnsInitialSet);

[answerX, answerY, matrixResult]        = sievingStepOrd(GAFExp, matrixResult, separation);

% In order to remove the sieving step, comment the previous line and
% uncomment the following one:
%[answerX, answerY]                     =   ind2sub([size(GAFExp,1), size(GAFExp,2)], matrixResult);