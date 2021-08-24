function out=cleanName(varargin)
%cleanName  Concatenates the input and returns an array of char.
%
%   Usage:  out=cleanName(varargin)
%
%   Input:
%
%   varargin            :   an array of strings.
%
%   Output:
%   out                 :   an array of chars with the same content as the input.
%
%---------------------------------------------------------  

if (nargin == 0)
    msg = 'Usage: cleanName(str)';
    error(msg);
end  
out='';
if (length(varargin) == 1)
     out = sprintf('%s',varargin{1});
else
    for ii=1:length(varargin)
        out=sprintf([out, varargin{ii}]);
    end
end
out=char(out);
end