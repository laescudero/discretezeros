function [answerX, answerY, matrixResult] = sievingStepNonOrd(expMatrix, locminmatrix, separation)
%sievingStepNonOrd  Sieving step denoted as S1 in our manuscript removing Steps 2 and 3.
%
%   Usage:  [answerX, answerY, matrixResult] = sievingStepNonOrd(expMatrix, locminmatrix, separation)
%
%   Input:
%
%   expMatrix       :   a matrix that contains the samples of a random entire function as in Eq. (2.9).
%   locminmatrix    :   an array of the estimation of the zero set using linear-indexing with respect to expMatrix.
%   separation      :   an integer specifying the target separation.
%
%   Output:
%   answerX         :   an array containing the first coordinate of the numerical zeros.
%   answerY         :   an array containing the second coordinate of the numerical zeros.
%   matrixResult    :   an array containing the coordinates of the zeros in linear indexing.
%---------------------------------------------------------

rowsNumber                                                = size(expMatrix,1);
columnsNumber                                             = size(expMatrix,2);
%
L                                                         = [separation, 1:separation-1, separation+1:(2*separation-1)];
[I,J]                                                     = ndgrid(L,L);
shifts                                                    = (sub2ind([rowsNumber,columnsNumber],I(:),J(:)));
shifts                                                    = shifts - shifts(1);
chosen                                                    = [];
while(not(isempty(locminmatrix)))
    chosen(end+1)                                                   = locminmatrix(1);
    separationDeltaRemoval                                          = locminmatrix(1) + shifts;
    locminmatrix(ismember(locminmatrix, separationDeltaRemoval))    = [];
end
%
matrixResult                                              = chosen;
[answerX,answerY]                                         = ind2sub([rowsNumber, columnsNumber],matrixResult);
