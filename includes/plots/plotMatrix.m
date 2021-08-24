function out = plotMatrix(matrix, zReal, zImag, bartf)
%plotMatrix  Log-scaled plot of a matrix with positive real coefficients.
%   Usage:  out = plotMatrix(matrix, zReal, zImag, bartf);
%           out = plotMatrix(matrix, zReal, zImag);
%
%   Input:
%   matrix           :  a 2D matrix to be plotted.
%   zReal            :  an array indicating the first dimension coordinates.
%   zImag            :  an array indicating the second dimension coordinates.
%   bartf            :  a boolean indicating whether to plot a colorbar or not (default value: true).
%   cRange           :  a global variable (either defined in parameters.m or in the calling script) that defines the range for the colorbar. 
%                       (follows the convention [minRange, maxRange]).
%
%   Output:
%   out              :  a handle for the graphical object.
%
%---------------------------------------------------------
global cRange;

if (~exist('bartf','var')); bartf=true; end;
out = imagesc([zReal(1), zReal(length(zReal))], [zImag(length(zImag)), zImag(1)], rot90(20*log10(matrix)), cRange);
colormap(ltfat_inferno);
axis xy;
if (bartf); colorbar; end;
if (~bartf); axis equal; end;
xlabel('Re(z)');
ylabel('Im(z)');
drawnow;