function [answerX, answerY, matrixResult] = ST_NoSiev(GAFExp, threshold)
%ST_NoSiev  Obtain numerical zeros via simple thresholding without sieving step.
%
%   Usage:  [answerX, answerY, matrixResult] = ST_NoSiev(GAFExp, threshold);
%
%   Input:
%
%   GAFExp          :   a matrix that contains the samples of a random entire function as in Eq. (2.9).
%   threshold       :   the threshold that is applied to estimate the zero set.
%
%   Output:
%   answerX         :   an array containing the first coordinate of the numerical zeros.
%   answerY         :   an array containing the second coordinate of the numerical zeros.
%   matrixResult    :   an array containing the coordinates of the zeros in linear indexing.
%
%---------------------------------------------------------

rowsNumber          =   size(GAFExp,1);
columnsNumber       =   size(GAFExp,2);

[rowsInitialSet, columnsInitialSet]     =   find(GAFExp <= threshold);
matrixResult                            =   sub2ind([size(GAFExp,1), size(GAFExp,2)],rowsInitialSet, columnsInitialSet);
[answerX, answerY]                      =   ind2sub([size(GAFExp,1), size(GAFExp,2)], matrixResult);