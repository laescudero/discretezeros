function [ out, fftz ] = ffft(f, alpha, fftz)
%ffft  Compute the fractional Fourier transform of f and parameter alpha.
%   Usage:  [ out, fftz ] = ffft(f, alpha, fftz);
%           [ out, fftz ] = ffft(f, alpha);
%
%   Input:
%
%   f           :   a sequence of complex values.
%   alpha       :   the parameter \alpha used in Eq. (1) in [1].
%   fftz        :   (optional) the sequence z defined in Eq. (16) in [1].
%
%   Output:
%   out         :   the fractional Fourier transform of f and parameter alpha.
%   fftz        :   the sequence z defined in Eq. (16) in [1].
%
%   References:
%   [1]   D. H. Bailey and P. N. Swarztrauber, The fractional Fourier transform and
%         applications, SIAM Rev. 33 (1991), no. 3, 389–404.
%---------------------------------------------------------

m = length(f);

orsize = size(f);

if size(f,1) > size(f,2)
  f=f.';
end

y      = zeros(1,2*m);
z      = zeros(1,2*m);
j      = zeros(1, m);
j(1:m) = (1:m)-1;

y(1:m) = f.*exp(-pi .* 1i .* alpha .* j.^2);

if ~exist('fftz','var')
  z(1:m)     = exp(pi.* 1i .* alpha .* j.^2);
  z(m+1:2*m) = exp(pi .* 1i .* alpha .* (( (m:2*m-1) - 2*m).^2));
  fftz       = fft(z);
end

k     = zeros(1,m);
k(1:m)= (1:m)-1;

res = ( ifft( fft(y).* fftz )) ;
out = exp(-pi * 1i * k.^2 .* alpha  ) .* (res(1:m)); % 

if not(size(out) == orsize)
  out = out.';
end
