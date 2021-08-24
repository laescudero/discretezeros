function [answerX, answerY, matrixResult] = MGN(GAFExp)
%MGN  Obtain numerical zeros via MGN.
%
%   Usage:  [answerX, answerY, matrixResult] = MGN(GAFExp)
%
%   Input:
%
%   GAFExp          :   a matrix that contains the samples of a random entire function as in Eq. (2.9).
%
%   Output:
%   answerX         :   an array containing the first coordinate of the numerical zeros.
%   answerY         :   an array containing the second coordinate of the numerical zeros.
%   matrixResult    :   an array containing the coordinates of the zeros in linear indexing.
%
%---------------------------------------------------------
             
rowsNumber          =   size(GAFExp,1);
columnsNumber       =   size(GAFExp,2);

% We set the shifts to compare a point 'X' with its 1-delta 'A' neighbors:
% A A A
% A X A
% A A A

distanceDelta = 1;
shifts = shiftsGrid(distanceDelta);

[rowsInitialSet, columnsInitialSet]     =   find(abs(GAFExp(2:rowsNumber-1,2:columnsNumber-1)) <= abs(GAFExp(2+shifts(1,1):rowsNumber-1+shifts(1,1), 2+shifts(1,2):columnsNumber-1+shifts(1,2))));
matrixResult                            =   sub2ind([size(GAFExp,1), size(GAFExp,2)],1+rowsInitialSet,1+columnsInitialSet);

% We store the local minima in the variable matrixResult. 
% We use linear indexing to make the comparison with the other neighboring bins.

for j=2:size(shifts, 1)
    matrixResult                        =   matrixResult(abs(GAFExp(matrixResult)) <= abs(GAFExp(matrixResult+shifts(j,1)*rowsNumber+shifts(j,2))));
end

[answerX, answerY]                      =   ind2sub([size(GAFExp,1), size(GAFExp,2)], matrixResult);