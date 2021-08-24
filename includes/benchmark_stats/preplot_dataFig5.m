% This script computes the data displayed in Figure 5.

close all

%---------------------------------------------------------
% Auxiliary functions for numerical computations.
%---------------------------------------------------------

pcf                                                         = @(r0) (((sinh(((pi/2).*(r0.^2))).^2 + ((pi/2).*(r0.^2)).^2).*cosh(((pi/2).*(r0.^2)))-2*((pi/2).*(r0.^2)).*sinh(((pi/2).*(r0.^2))))./(sinh(((pi/2).*(r0.^2))).^3));
pcf_distance                                                = @(x,y,z,w) pcf(1/sqrt(pi) * sqrt((x-z).^2 + (y-w).^2));  
integralVariance                                            = @(a,b) (1/pi).^2 * integral(@(x)integral3(@(y,z,w) pcf_distance(x,y,z,w), 0,b,0,a,0,b,'AbsTol',1e-5),0,a,'AbsTol',1e-5,'ArrayValued',true);
variance_rectangle                                          = @(a,b) (a*b/pi*(1-a*b/pi) + integralVariance(a,b));
variance_square                                             = @(x) arrayfun(variance_rectangle, x,x);

%---------------------------------------------------------
% If the numerical data is not present, we compute it.
%---------------------------------------------------------

if (exist(fileNumD,'file'))
    load(fileNumD)
end

%---------------------------------------------------------
% Loading simulations results.
%---------------------------------------------------------

load(fileSimR);

software                                                    = double(exist('OCTAVE_VERSION', 'builtin') ~= 0)+1;

%---------------------------------------------------------
% Statistics on the true and estimated zeros.
%---------------------------------------------------------

if(nonZeroMeanMode)
    estimatorFI                                                 = numberZerosInnerBoxTotal;
    errorEstExp                                                 = estimatorFI;
    numberZerosInnerBoxSevTotMean                               = mean(numberZerosInnerBoxSevTotal, 2);
    numberZerosInnerBoxSevTotSD                                 = sqrt(var(numberZerosInnerBoxSevTotal, 0, 2));
    errorNumberZerosInnerBoxSevTotMean                          = zeros(size(numberZerosInnerBoxSevTotMean));
    measureBoxes                                                = (2.*[boxSizes]).^2;
    for ii=1:size(numberZerosInnerBoxSevTotMean,1)
        for iii=1:size(numberZerosInnerBoxSevTotMean,3)
            for iv=1:size(numberZerosInnerBoxSevTotMean,4)
                % The following line computes the estimator in (5.13).
                errorNumberZerosInnerBoxSevTotMean(ii,1,iii,iv) = (numberZerosInnerBoxSevTotMean(ii,1,iii,iv)-expZerosNZM(fsym, fsymdiff, -boxSizes(iv), boxSizes(iv), -boxSizes(iv), boxSizes(iv), sd_noise)) ./ measureBoxes(iv);
            end
        end
    end
  
    close all
    
    dataFig5Folder = cleanName(['./',outputFolder,'/','dataFig5']);
    if ~exist(dataFig5Folder,'dir');    mkdir(dataFig5Folder); end
    fileTableEstNZM =cleanName(['./',outputFolder,'/','dataFig5','/','tableEstimator','_',experimentName,'.dat']);
    fTableEstNZM = fopen (fileTableEstNZM, 'w+', 'native');
    fprintf(fTableEstNZM,'L ');
    for iii=1:zeDetectNo;
      fprintf(fTableEstNZM,'%s ',zeroDetectionLabel{iii});
    end
    fprintf(fTableEstNZM,'\n');

    for ii=1:length(boxSizes)
        fprintf(fTableEstNZM,'%d ',ii);
        for iii=1:zeDetectNo;
          fprintf(fTableEstNZM,'%.7f ',squeeze(errorNumberZerosInnerBoxSevTotMean(end, 1, iii, ii)));
        end
        fprintf(fTableEstNZM,'\n');
    end
    fclose(fTableEstNZM);
end
