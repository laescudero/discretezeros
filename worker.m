% This script first computes the Bargmann transform of 
% complex white noise with a deterministic component as 
% described in Section 5 of our manuscript.
% Then, it applies AMN and other methods to estimate the 
% zeros set and counts the number of zeros in different
% regions to carry the computations of Sections 5.3 and 5.4.
% The quantities here obtained are further processed by 
% the script statsims.m.
%---------------------------------------------------------
software                                                    = double(exist('OCTAVE_VERSION', 'builtin') ~= 0)+1;
if ~(software == 1)
    if (~exist('parallelMode','var') || ~exist('distributedComputation','var') || (exist('parallelMode','var') && parallelMode==true) )
        addpath(genpath(['./includes/']))

        parameters

        fileTmpDataD = cleanName(['./',tmpFolder,'/',fileTmpData,'.mat']);

        load(fileTmpDataD);

        fileLock    = [tmpFolder,'/',int2str(indexRuns),'.lock'];
        fileResults = ['./',tmpFolder,'/',partialResults,'_',int2str(indexRuns),'.mat'];

        testvariable=1;

        save('-ascii', fileLock, 'testvariable');

        zerosHighRes = cell(1,zeDetectNo);
    end
end

close all

try

    for indexResolution = (length(delta_GAF):-1:1)
        if (indexResolution == length(delta_GAF))
            if (~addNoise); noiseVector = 0 .* noiseVector; end;
            if (nonZeroMeanMode)
                H_mu                                            = linspace(-L-T, L+T, sigLengthTotal).';
                little_f1_normalized                            = delta_GAF(indexResolution) .* little_f1(H_mu);
                f_to_transform                                  = little_f1_normalized;
                if(indexRuns==1)
                    fprintf('*) Computing the Bargmann transform of f_1 without noise. ');
                    [GAFExpNoNoise, zReal, zImag] = computeBargmann(f_to_transform, delta_GAF(indexResolution), T, L);
                    hf=figure(5);
                    if (length(zReal) > 20000)
                        plotMatrix(ctMatrix(ctMatrix(ctMatrix(abs(GAFExpNoNoise), baseDelta), baseDelta), baseDelta), ctMatrix(ctMatrix(ctMatrix(zReal, baseDelta), baseDelta), baseDelta), ctMatrix(ctMatrix(ctMatrix(zImag, baseDelta), baseDelta), baseDelta));
                    else
                        plotMatrix(abs(GAFExpNoNoise), zReal, zImag);
                    end         
                    filenameW = cleanName([folderResults,'/',experimentName,'_without_noise','.png']);
                    drawnow
                    savePlot(software, hf, filenameW, 5);
                end
                clear GAFExpNoNoise
                deterministic_function                          = little_f1_normalized;
                f_to_transform                                  = noiseVector + deterministic_function;
            else
                f_to_transform                                  = noiseVector;
            end
            
            if (nonZeroMeanMode)
                fprintf('*) Computing the Bargmann transform of \\sigma f_0 + f_1. ');
            else
                fprintf('*) Computing the Bargmann transform of \\sigma f_0. ');
            end
            
            [GAFExp, zReal, zImag] = computeBargmann(f_to_transform, delta_GAF(indexResolution), T, L);
        else
            fprintf('-) Subsampling transform.\n')
            zReal                                               = ctMatrix(zReal, baseDelta);
            zImag                                               = zReal;
            GAFExp                                              = ctMatrix(GAFExp, baseDelta);
        end

        %---------------------------------------------------------
        % We plot the transform for the first realization of each 
        % resolution if the flag plotSpectrograms is TRUE.
        %---------------------------------------------------------

        if(plotSpectrograms && indexRuns==1)
            A = figure(1);
            if length(zReal) > 20000
                plotMatrix(ctMatrix(ctMatrix(ctMatrix(abs(GAFExp), baseDelta), baseDelta), baseDelta), ctMatrix(ctMatrix(ctMatrix(zReal, baseDelta), baseDelta), baseDelta), ctMatrix(ctMatrix(ctMatrix(zImag, baseDelta), baseDelta), baseDelta));
            else
                plotMatrix(abs(GAFExp), zReal, zImag);
            end
        end

        %---------------------------------------------------------
        % Estimating the zero set.
        %---------------------------------------------------------

        fprintf('**) Estimating the zero set.\n');

        for indexMethod=1:length(zeroDetection)  
            fprintf('***) Method %s. ',zeroDetectionLabel{indexMethod})    
            chosenMethod                                        = zeroDetection{indexMethod};
            [locminxind,locminyind,locminmatrix]                = chosenMethod(GAFExp, delta_GAF, indexResolution, zReal, zImag);          

            % Converting matrix indices into coordinates in the plane.
            locminxK                                            = zReal(locminxind);
            locminyK                                            = zImag(locminyind);

            %---------------------------------------------------------
            % We plot the detected zeros.
            %---------------------------------------------------------

            if(plotSpectrograms && indexRuns==1)
                hf=figure(1);
                hold on
                C=scatter(locminxK,locminyK, scatterSize, 'b');
                filenameW = cleanName([folderResults,'/',zeroDetectionLabel{indexMethod},'_Res_',num2str(indexResolution),'.png']);
                pause(1)
                savePlot(software, hf, filenameW,1);
                hold off
                if(exist('C','var')==1); delete(C); end;
            end

            if (indexResolution == length(delta_GAF) && indexMethod==1)
                zerosHighRes    = locminmatrix;
                zRealHighRes    = zReal;
                zImagHighRes    = zImag;
            else
                fprintf('Testing Eq. (5.14). ')
                zeroSetsDifferenceBoxPartial(indexResolution, indexRuns, indexMethod)  = zerosDifference(locminmatrix, zReal, zImag, zerosHighRes, zRealHighRes, zImagHighRes, 2, sizeBox_tables_1_and_3);
            end
                        
            %---------------------------------------------------------
            % Counting zeros.
            %---------------------------------------------------------
            % We count the number of numerical zeros located inside a
            % square centered at the origin with sides of length 2*(L-1), 
            % namely the set [-(L-1), (L-1)] x [-(L-1), (L-1)] in the complex plane. 
            %---------------------------------------------------------

            fprintf('Counting zeros for (5.10) and (5.13).\n')
            numberZerosInnerBoxPartial(indexResolution, indexRuns, indexMethod)    = countInCentralBox(locminxK, locminyK, sizeBox_tables_1_and_3, delta_GAF(indexResolution));
            if(nonZeroMeanMode)
                for indexBoxSize=1:length(boxSizes)
                    numberZerosInnerBoxSevPartial(indexResolution, indexRuns, indexMethod, indexBoxSize)    = countInCentralBox(locminxK, locminyK, boxSizes(indexBoxSize), delta_GAF(indexResolution));
                end
            end
        end
    end

    clear GAFExp referenceZeros zerosHighRes zRealHighRes zImagHighRes  

    if(~(software==1) && (parallelMode || distributedComputation))
        save(fileResults, 'zeroDetectionLabel', 'zeDetectNo', 'numberZerosInnerBoxSevPartial', 'numberZerosInnerBoxPartial', 'zeroSetsDifferenceBoxPartial');
        delete(fileLock);
    end

 catch

    if(~(software==1) && (parallelMode || distributedComputation))
        delete(fileLock);
    end

end