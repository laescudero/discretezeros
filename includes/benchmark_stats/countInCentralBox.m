function out = countInCentralBox(zerosX, zerosY, sizeBox, delta)
%countInCentralBox  Counts the number of zeros in the rectangle [-sizeBox, sizeBox]^2.
%
%   Usage:  out = countInCentralBox(zerosX, zerosY, sizeBox, delta)
%
%   Input:
%
%   zerosX              :   an array containing the real coordinates of the zeros.
%   zerosY              :   an array containing the imaginary coordinates of the zeros.
%   sizeBox             :   a numerical value indicating the size of the square centered at the origin.
%   delta               :   a numerical value indicating the resolution of the grid.
%
%   Output:
%   out                 :   the number of zeros in [-sizeBox, sizeBox]^2.
%
%---------------------------------------------------------  

out = length(zerosBox(zerosX, zerosY, sizeBox, delta));