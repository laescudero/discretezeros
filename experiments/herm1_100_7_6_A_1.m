%---------------------------------------------------------
% Experiment parameters
%---------------------------------------------------------

% The simulation of the Bargmann transform is performed on
% [-L, L] x [-L, L] in the complex plane.
L                                                             = 7;
% The different grid resolutions that are considered (delta_GAF) 
% are given by negative integer powers of baseDelta. 
% The coarsest grid resolution is given by exp1 and the
% finest grid is defined by exp2.
% By default, we considered 2^(-4), 2^(-5), ..., 2^(-8), 2^(-9).
baseDelta                                                     = 2;
exp1                                                          = 4;
exp2                                                          = 9;
delta_GAF                                                     = baseDelta.^[-exp1:-1:-exp2];
% The estimator (5.15), whose results are in Table 3, is computed
% counting zeros on [-(L-1), (L-1)] x [-(L-1), (L-1)] in the 
% complex plane.
% As in the manuscript, we use sizeBox_tables_1_and_3 = L-1.
sizeBox_tables_1_and_3                                        = L-1;
% The gaussian window is truncated in [-T, T].
T                                                             = 6;
% Number of realizations to be computed.
runs                                                          = 100;
% Add noise to the signal.
addNoise                                                      = true;
% Noise standard deviation.
sd_noise                                                      = 1;
% Specify whether the signal little_f1 has to be processed.
nonZeroMeanMode                                               = true;
% Value of A in (2.11).
A_const                                                       = 1;
% Constant to achieve a particular value for A.
C_const                                                       = A_const * exp(1/2);
% Function from which the deterministic part will be computed.
little_f1                                                     = @(t) C_const .* 2 .* t .* exp(- (t.^2));
% fsym is the Bargmann transform of f_1, denoted as F^1 in our manuscript.
% This is required to compute (3.10) and then (5.13).                                                    
fsym                                                          = @(z) C_const .* z;
% Derivative of the Bargmann transform of f_1 to define the first 
% intensity (3.10) when computing (5.13).                                                         
fsymdiff                                                      = @(z) C_const .* 1;
% Values for L_1 in the experiments defined in Sect. 5.3.2 
% displayed with Fig. 5.                        
boxSizes                                                      = 1:6;