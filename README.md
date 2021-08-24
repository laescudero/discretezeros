# Discretezeros
The present code implements the algorithms and tests specified in the article:
"Efficient computation of the zeros of the Bargmann transform".

## Requirements
- [Octave](https://www.gnu.org/software/octave/index).
- Any LaTeX distribution with latexmk. (Only if you want to compile the results exported in that format)

## Instructions
To execute the code, install [Octave](https://www.gnu.org/software/octave/index) and run **main.m**.

The program will ask you whether:
- you want to load all the available experiments,
- you want to compute the simulations, obtain the statistics of already performed simulations, or to perform both tasks.

Alternatively, you can run **demo_zerofinding.m**, which allows you to visualize a single realization of the Bargmann transform of complex white noise, and its zero set.

## Main.m
In the folder *experiments/* there are separate files that define the values of the constants and functions to which the algorithms described in Section 5 of the manuscript will be applied.

The first part of the script consists of:

- loading each experiment,
- computing the Bargmann transform and its zero set (as described in described in Section 5.2),
- counting the number of zeros required to calculate the proposed estimators in Sections 5.3 and 5.4,
- saving the data for further processing.

The second part of the script consists of:

- computing the estimators (5.10), (5.13), and (5.15),
- exporting Table 1 and the columns compared in Table 3 (as .tex files),
- exporting a .tex file describing the plots obtained in the previous step,
- exporting the subplots of Figure 5 (rendered by Octave/MATLAB),
- exporting the information used to produce Figure 5,
- calling the LaTeX compiler.

All files are saved in the folder *results/(name of the experiment)/*.

## Configuration
Parameters related to code execution, plots, and folder names can be found in the file parameters.m. In particular, the user will find the flag seedMode there, which when set to true defines the implicit parameter of the random number generator to the value considered when computing the results displayed in the manuscript.

## Parallelization
There are two possibilities to speed up the software computation. 

- parallelMode: this option defines whether multiple threads in the same host will be used. The number of threads is set by changing the number stored in the plaintext file maxWorkers.txt.

- distributedComputation: this feature enables computation across several servers. For this feature to work properly, you must ensure that you have a Linux cluster with a shared directory structure and a public-key SSH authentication system.
The username and hostname pool can be specified in the same file.
While this method has some failover features, it is entirely experimental and should be used at your discretion. The total number of threads is adjusted by changing the value stored in maxWorkers.txt.

## Compatibility with MATLAB
The script runs both in Octave and MATLAB. However, the features seedMode, parallelMode, and distributedComputation work only with Octave.