projectdir = pwd;
addpath(genpath([pwd,'/','includes']))

% The simulation of the Bargmann transform is performed on
% [-L, L] x [-L, L] in the complex plane.
L = 20;

% grid resolution
delta_GAF = 2^(-4);

% The gaussian window is truncated in [-T, T].
T = 6;

% Noise standard deviation.
sd_noise = 1;

% Deterministic function added to noise 
% Choose one, comment the others
little_f1 = @(t) 0;      
%little_f1 = @(t) 100 * exp(- (t.^2));        
%little_f1 = @(t) 100 * exp(1/2) .* 2 .* t .* exp(- (t.^2));  

% Choose a zero detection algorithm, comment the others
zeroDetection = @(a,b,c,d,e) AMN(a, b(c), d, e);
%zeroDetection = @(a,b,c,d,e) MGN(abs(a));
%zeroDetection = @(a,b,c,d,e) ST(abs(a), 2*b(c));
%zeroDetection = @(a,b,c,d,e) ST_NoSiev(a, 1*b(c));


H_w = [-T:delta_GAF(end):T].';
sigLength = length(-L:delta_GAF(end):L);
sigLengthTotal = sigLength + length(H_w);

% Generating noise samples.

qnoise = sd_noise .* sqrt(delta_GAF .* sqrt(pi/2)) .* (sqrt(0.5) .* ( randn(sigLengthTotal, 1) + 1i .* randn(sigLengthTotal, 1) ));

H_mu                   = linspace(-L-T, L+T, sigLengthTotal).';
little_f1_normalized   = delta_GAF .* little_f1(H_mu);
deterministic_function = little_f1_normalized;
noiseVector            = qnoise;
f_to_transform         = noiseVector + deterministic_function;

[GAFExp, zReal, zImag] = computeBargmann(f_to_transform, delta_GAF, T, L);
% Range for plots
global cRange
cRange = [-60, 10];
plotMatrix(abs(GAFExp), zReal, zImag);

% Calculate zeros
[locminxind,locminyind,locminmatrix] = zeroDetection(GAFExp, delta_GAF, 1, zReal, zImag);          

% Converting matrix indices into coordinates in the plane.
locminxK = zReal(locminxind);
locminyK = zImag(locminyind);

hold on
  scatter(locminxK,locminyK, 40, 'b');
hold off


                