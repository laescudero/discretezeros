% This script loads the results obtained for each realization of complex white noise and computes the estimators specified in Sec. 5.

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

if (~nonZeroMeanMode && ( ~exist('numericalVariance_only_integral', 'var') || not(exist('centralBoxSize_saved','var')) || any(centralBoxSize_saved  ~= sizeBox_tables_1_and_3) ))
	fprintf('Computing numerical integral for comparison between empirical and theoretical results.\n\n');
	sideLengthRect                                          = [sizeBox_tables_1_and_3'  , sizeBox_tables_1_and_3'];
	numericalVariance_only_integral                         = integralVariance(2*sizeBox_tables_1_and_3, 2*sizeBox_tables_1_and_3);
	centralBoxSize_saved                                    = sizeBox_tables_1_and_3;
	save(fileNumD, 'numericalVariance_only_integral','centralBoxSize_saved');
end

%---------------------------------------------------------
% Loading simulations results.
%---------------------------------------------------------

load(fileSimR);

software                                                    = double(exist('OCTAVE_VERSION', 'builtin') ~= 0)+1;

%---------------------------------------------------------
% Statistics on the true and estimated zeros.
%---------------------------------------------------------

measureBoxL   								                    = (2*sizeBox_tables_1_and_3)^2;

% Figure 5
if(nonZeroMeanMode)
	estimatorFI                                                 = numberZerosInnerBoxTotal;
	errorEstExp                                                 = estimatorFI;
	numberZerosInnerBoxSevTotMean 								= mean(numberZerosInnerBoxSevTotal, 2);
	numberZerosInnerBoxSevTotSD 								= sqrt(var(numberZerosInnerBoxSevTotal, 0, 2));

	for ii=1:length(boxSizes)
		expectedZeros(ii)										= expZerosNZM(fsym, fsymdiff, -boxSizes(ii), boxSizes(ii), -boxSizes(ii), boxSizes(ii), sd_noise);
	end

	errorNumberZerosInnerBoxSevTotMean							= zeros(size(numberZerosInnerBoxSevTotMean));
	measureBoxes												= (2.*[boxSizes]).^2;

	for ii=1:size(numberZerosInnerBoxSevTotMean,1)
		for iii=1:size(numberZerosInnerBoxSevTotMean,3)
			for iv=1:size(numberZerosInnerBoxSevTotMean,4)
				% The following line computes the estimator in (5.13).
				errorNumberZerosInnerBoxSevTotMean(ii,1,iii,iv)	= (numberZerosInnerBoxSevTotMean(ii,1,iii,iv)-expectedZeros(iv)) ./ measureBoxes(iv);
			end
		end
	end

	close all

	markerType = {'+','o','*','.','x','s','d','^','v','>','<','p','h'};

	hf=figure(6);
	hold on

	for ii=1:zeDetectNo
		plot(boxSizes, squeeze(errorNumberZerosInnerBoxSevTotMean(end, 1, ii, :)), markerType{ii}, 'markersize', 12)
	end

	plot([min(boxSizes),max(boxSizes)],[0,0],'k-')
	legend(zeroDetectionLabel)
	axPlot = axis;

	if(max(abs(squeeze(errorNumberZerosInnerBoxSevTotMean(end, 1, ii, :)))) > 0.2)
		axis([axPlot(1), axPlot(2), -0.5, 0.5]);
	else
		axis([axPlot(1), axPlot(2), -0.2, 0.2]);
	end

	xlabel('L_{1}','interpreter','tex');
	ylabel('\hat{\beta}_{R}(\Omega_{L_{1}}, \delta_{Hi}))','interpreter','tex');
	hold off

	% Saving plot.
	filePlotEv	= cleanName(['./',outputFolder,'/',experimentName,'/','plotZeInBox','_',experimentName,'.png']);
	filenameW = filePlotEv;
	pause(4);
	savePlot(software, hf, filenameW,6);

else
	estimatorFI                                                 = numberZerosInnerBoxTotal./measureBoxL;
	errorEstExp                                                 = estimatorFI - 1/pi;
	varianceExpectedZeros                                       = numericalVariance_only_integral - (( measureBoxL )/pi)^2 + measureBoxL/pi;
	varianceEstimatorTheoretical                                = varianceExpectedZeros/measureBoxL^2;
	sdTheoretical                                               = sqrt(varianceEstimatorTheoretical);
end

meanError                                                   = reshape(mean(errorEstExp, 2), size(errorEstExp,1), size(errorEstExp,3));
varianceEmpirical                                           = var(errorEstExp, 0, 2);
sdEmpirical                                                 = sqrt(varianceEmpirical);
pmchar								                        = '+/-';

eqn = func2str(little_f1); 
eqn2 = eqn(5:end);
eqn2=strrep(eqn2,'*','');
eqn2=strrep(eqn2,'.*','');
eqn2=strrep(eqn2,'.^','^');
eqn2=strrep(eqn2,'./','/');
eqn2=strrep(eqn2,'exp','\exp');
eqn2=strrep(eqn2,'sin','\sin');
eqn2=strrep(eqn2,'cos','\cos');
eqn2=strrep(eqn2,'(t ^ 2)','t^2');
eqn2=strrep(eqn2,'C_const','C');
eqn2=strrep(eqn2,'.','');

%%% Latex commands
headerLatexDoc = '\\documentclass[10pt,a4paper]{article}\n\\usepackage[utf8]{inputenc}\n\\usepackage[T1]{fontenc}\n\\usepackage{amsmath}\n\\usepackage{amsfonts}\n\\usepackage{amssymb}\n\\usepackage{booktabs}\n\\usepackage{graphicx}\n\\usepackage{subcaption}\n\\begin{document}\n';
footerLatexDoc = '\\end{document}';

headerTable = '\\begin{table}[tbh]\n\\centering\n';
footerTable = '\\bottomrule\n\\end{tabular}\n\\end{table}\n';

%%% Table 1 for Pure Noise - Estimator and Variance
if (~nonZeroMeanMode)
	fTableMeanSD = fopen (fileTableMeanSD, 'w+', 'native');
	[filepath, fileTableMeanSDName, ext] = fileparts(fileTableMeanSD);
	fprintf(fTableMeanSD, headerLatexDoc);
	fprintf(fTableMeanSD, headerTable);
	
	fprintf(fTableMeanSD,'\\caption{Empirical means $\\pm$ standard deviations of the estimation errors $\\widehat{\\rho}(\\Theta, r, \\delta) - 1/\\pi$ for $\\Theta=\\Omega_{L-1}$, $L=%.2g$ and $R=%d$ independent realizations. For a faithful detection of the zero set $\\{F=0\\}$ the mean should be zero and the standard deviation $%.5f$.}\\vspace{1mm}\n', L, runs, sdTheoretical);
	
	fprintf(fTableMeanSD,'\\label{%s}\n', fileTableMeanSDName);
	fprintf(fTableMeanSD,'\\begin{tabular}{cccc}\n');
	
	fprintf(fTableMeanSD,'\\toprule\n');
	
    fprintf(fTableMeanSD, '$\\delta$ ');
    for iii=1:zeDetectNo
      fprintf(fTableMeanSD,'& %s',zeroDetectionLabel{iii});
    end
	fprintf(fTableMeanSD,'\\\\ \n');

	fprintf(fTableMeanSD,'\\midrule\n');

	for ii=1:length(delta_GAF)
      fprintf(fTableMeanSD,'$ %d^{%d} $ 	', baseDelta, log(delta_GAF(ii))/log(baseDelta));
      colPrint = sprintf('& $ %%+.%df \\\\pm %%.5f $ ', max(ceil(-log10(min(min(abs(meanError))))), 5));
      for iii=1:zeDetectNo
		    fprintf(fTableMeanSD, colPrint ,meanError(ii, iii), sdEmpirical(ii,iii));
      end
      fprintf(fTableMeanSD,'\\\\ \n');
	end

	fprintf(fTableMeanSD,footerTable);
	fprintf(fTableMeanSD,footerLatexDoc);
	
	fclose(fTableMeanSD);
end

%%% Table 3 - Probability of Failure 

fTablePfal = fopen (fileTablePfal, 'w+', 'native');
[filepath, fileTablePfalName, ext] = fileparts(fileTablePfal);
fprintf(fTablePfal, headerLatexDoc);
fprintf(fTablePfal, '\\setcounter{table}{2}\n');
fprintf(fTablePfal, headerTable);
if(nonZeroMeanMode)
	fprintf(fTablePfal, '\\caption{Estimation of the failure probability $p(\\delta_{k}, M)$ in the sense of Theorem 2.1, in the domain $\\Omega_{L-1}$ with parameters $\\delta_{\\text{Hi}}=%d^{%d}$, $T=%.2g$, and $L=%.2g$. Averages are computed over $R=%d$ realizations of complex white noise with standard deviation $\\sigma=%.2g$ plus signal $f^{1} (t) =%s$. The function was rescaled so that $A=%.2g$ in Eq. (2.11).} \\vspace{1mm}\n', baseDelta, log(delta_GAF(end))/log(baseDelta), T, L, runs, sd_noise, eqn2, A_const);
else
	fprintf(fTablePfal, '\\caption{Estimation of the failure probability $p(\\delta_{k}, M)$ in the sense of Theorem 2.1, in the domain $\\Omega_{L-1}$ with parameters $\\delta_{\\text{Hi}}=%d^{%d}$, $T=%.2g$, and $L=%.2g$. Averages are computed over $R=%d$ realizations of pure complex white noise with standard deviation $\\sigma=%.2g$.} \\vspace{1mm}\n', baseDelta, log(delta_GAF(end))/log(baseDelta), T, L, runs, sd_noise);
end

fprintf(fTablePfal, '\\label{%s}  \n', fileTablePfalName);
fprintf(fTablePfal, '\\begin{tabular}{cccc} \n');

fprintf(fTablePfal, '\\toprule \n');

fprintf(fTablePfal, '$\\delta$ ');
for iii=1:zeDetectNo
  fprintf(fTablePfal,'& %s',zeroDetectionLabel{iii});
end
iii=zeDetectNo;
fprintf(fTablePfal,'\\\\ \n');

fprintf(fTablePfal,'\\midrule\n');

for ii=1:length(delta_GAF)
  fprintf(fTablePfal,'$ %d^{%d} $ 	', baseDelta, log(delta_GAF(ii))/log(baseDelta));
  for iii=1:zeDetectNo
	colRes = sprintf('& $ %%.%df $ ', ceil(log10(runs)));
	fprintf(fTablePfal,colRes, failureProbability(ii, iii));
  end
  fprintf(fTablePfal,' \\\\ \n');
end

fprintf(fTablePfal, '\\bottomrule \n');

fprintf(fTablePfal,footerTable);
fprintf(fTablePfal,footerLatexDoc);

fclose(fTablePfal);

%%% Latex for figures
fidExp = fopen(filePlotCode, 'w', 'native');
fprintf(fidExp, headerLatexDoc);
for indexResolution = (length(delta_GAF):-1:1)
	fprintf(fidExp, '\\setcounter{figure}{3}\n');
	fprintf(fidExp,'\\begin{figure*}\n');
	fprintf(fidExp,'	\\centering\n');
	if(nonZeroMeanMode)
		fprintf(fidExp,'	\\begin{subfigure}[b]{0.475\\textwidth}   \n');
		fprintf(fidExp,'		\\centering \n');
		fprintf(fidExp,'		\\includegraphics[width=\\textwidth]{%s_without_noise}\n', experimentName);
		fprintf(fidExp,'		\\caption{No added noise.}    \n');
		fprintf(fidExp,'		\\label{fig_%s_nonoise_%g}\n',experimentName,indexResolution);
		fprintf(fidExp,'	\\end{subfigure}\n');
		fprintf(fidExp,'	\\hfill\n');
	end
	fprintf(fidExp,'	\\begin{subfigure}[b]{0.475\\textwidth}\n');
	fprintf(fidExp,'		\\centering\n');
	fprintf(fidExp,'		\\includegraphics[width=\\textwidth]{AMN_Res_%g}\n', indexResolution);
	fprintf(fidExp,'		\\caption{{\\small AMN}.}    \n');
	fprintf(fidExp,'		\\label{fig_%s_AMN_%g}\n',experimentName,indexResolution);
	fprintf(fidExp,'	\\end{subfigure}\n');
	fprintf(fidExp,'	\\vskip\\baselineskip\n');
	fprintf(fidExp,'	\\begin{subfigure}[b]{0.475\\textwidth}  \n');
	fprintf(fidExp,'		\\centering \n');
	fprintf(fidExp,'		\\includegraphics[width=\\textwidth]{MGN_Res_%g}\n', indexResolution);
	fprintf(fidExp,'		\\caption{{\\small MGN}.}    \n');
	fprintf(fidExp,'		\\label{fig_%s_MGN_%g}\n',experimentName,indexResolution);
	fprintf(fidExp,'	\\end{subfigure}\n');
	fprintf(fidExp,'	\\hfill\n');
	fprintf(fidExp,'	\\begin{subfigure}[b]{0.475\\textwidth}   \n');
	fprintf(fidExp,'		\\centering \n');
	fprintf(fidExp,'		\\includegraphics[width=\\textwidth]{ST_Res_%g}\n', indexResolution);
	fprintf(fidExp,'		\\caption{{\\small ST.}}    \n');
	fprintf(fidExp,'		\\label{fig_%s_ST_%g}\n',experimentName,indexResolution);
	fprintf(fidExp,'	\\end{subfigure}\n');
	
	if(nonZeroMeanMode)
		fprintf(fidExp, '	\\caption{A realization of $\\exp \\left(-|z|^{2} / 2\\right)\\left|\\left(\\sigma F^{0}(z)+F^{1}(z)\\right)\\right|$ where $F^{1}$ is the Bargmann transform of $f^{1}(t)=%s$ and $\\sigma=%.2g$. The deterministic functions are scaled with $C$ to obtain $A=%d$. Zeros computed with AMN, MGN, and ST are calculated from grid samples with $\\delta=%d^{%d}$. } \n', eqn2, sd_noise, A_const, baseDelta, log(delta_GAF(indexResolution))/log(baseDelta));
	else
		fprintf(fidExp, '	\\caption{A realization of $\\exp \\left(-|z|^{2} / 2\\right)\\left|\\left(\\sigma F^{0}(z)\\right)\\right|$ where $\\sigma=%.2g$. Zeros computed with AMN, MGN, and ST are calculated from grid samples with $\\delta=%d^{%d}$.} \n', sd_noise, baseDelta, log(delta_GAF(indexResolution))/log(baseDelta));
	end
	
	fprintf(fidExp,'	\\label{fig_%s_%g}\n',experimentName,indexResolution);
	fprintf(fidExp,'\\end{figure*}\n');
	fprintf(fidExp,'\n');
	if ~(indexResolution==1)
		fprintf(fidExp,'\\clearpage \n');
	end
end
fprintf(fidExp,footerLatexDoc);
fclose(fidExp);

fprintf('Results saved in %s/%s/%s \n',pwd,outputFolder,experimentName);

try 
    if ispc()
       chardir='\';
    else
       chardir='/';
    end
	dirresults 	= cleanName([outputFolder,chardir,experimentName]);
	commandTBE1 = cleanName(['del ',dirresults,chardir,'*.pdf']);
	system (commandTBE1); 
	commandTBE2 = cleanName(['latexmk -pdf -cd ',dirresults,'/*.tex']);
	system (commandTBE2); 
	commandTBE3 = cleanName(['del ',dirresults,chardir,'*.log ',dirresults,chardir,'*.fls ',dirresults,chardir,'*latexmk ',dirresults,chardir,'*.aux']);
	system (commandTBE3); 
end
	