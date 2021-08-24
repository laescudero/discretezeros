% This script sets the list of algorithms that will be used to estimate the set of zeros.
% The indices (a,b,c,d,e) are instanced as:
% a <- GAFExp           : samples of the input model (2.9).
% b <- delta_GAF        : a list of possible resolutions.
% c <- indexResolution  : the resolution chosen among those in delta_GAF.
% d <- zReal            : an array containing the real coordinates of the zeros.
% e <- zImag            : an array containing the imaginary coordinates of the zeros.

zeroDetection                                               = {};
zeroDetectionLabel                                          = {};
zeroDetection{1}                                            = @(a,b,c,d,e) AMN(a, b(c), d, e);
zeroDetectionLabel{1}                                       = 'AMN';
zeroDetection{2}                                            = @(a,b,c,d,e) MGN(abs(a));
zeroDetectionLabel{2}                                       = 'MGN';
zeroDetection{3}                                            = @(a,b,c,d,e) ST(abs(a), 2*b(c));
zeroDetectionLabel{3}                                       = 'ST';
zeDetectNo                                                  = length(zeroDetection);