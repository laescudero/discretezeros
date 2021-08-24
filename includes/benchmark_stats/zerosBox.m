function out = zerosBox(zerosX, zerosY, sizeBox, delta)
%zerosBox  Computes the set of zeros in the set [-sizeBox, sizeBox] x [-sizeBox, sizeBox]
%
%   Usage:  out = zerosBox(zerosX, zerosY, sizeBox, delta)
%
%   Input:
%
%   zerosX              :   an array containing the real coordinates of the zeros.
%   zerosY              :   an array containing the imaginary coordinates of the zeros.
%   sizeBox             :   the size of the square centered at the origin.
%   delta               :   the resolution of the grid.
%
%   Output:
%   out                 :   the indices of the elements of (zerosX, zerosY) that belong to the square of sides 2*sizeBox centered at the origin.
%
%---------------------------------------------------------  

out = find( ( (-sizeBox <= zerosX') & (zerosX' <= (sizeBox-delta/3)) ) & ( ( (-sizeBox <= zerosY') &  (zerosY' <= (sizeBox-delta/3)) ) ) );