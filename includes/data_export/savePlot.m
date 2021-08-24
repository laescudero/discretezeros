function savePlot(software, handle, filename, figure)
%savePlot Saves a plot.
%   Usage:  savePlot(software, handle, filename, figure)
%
%   Input:
%   software    :   an integer equal to 1 (Octave) or 2 (MATLAB). 
%   handle      :   the handle of the figure. (Only relevant in Octave)
%   filename    :   filename of the plot to be saved.
%   figure      :   the figure to be saved. (Only relevant in MATLAB)
%
%---------------------------------------------------------  

if software==1
    pause(1);
    saveas(handle, filename);
elseif software==2
    print(figure, filename);
end