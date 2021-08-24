function out = ctMatrix(matrix, avBins)
%ctMatrix  Returns only the rows/columns of matrix that are congruent to 1 mod avBins.
%          This is used to obtain a subsampled matrix.
%   Usage: out = ctMatrix(matrix, avBins)
%
%   Input:
%   matrix           :  a 2D matrix.
%   avBins           :  an integer.
%
%   Output:
%   out              :  a submatrix of the input formed from all the rows and columns that were congruent to 1 mod avBins.
%
%---------------------------------------------------------
rows                  = size(matrix,1);
cols                  = size(matrix,2);
deleteRows            = setdiff(1:rows, 1:avBins:rows);
deleteCols            = setdiff(1:cols, 1:avBins:cols);
out                   = matrix;
out(deleteRows, :)    = [];
out(:, deleteCols)    = [];

