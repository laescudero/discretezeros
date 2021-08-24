function shifts = shiftsGrid(deltaShift)
%shiftsGrid  Coordinates of grid elements having discrete norm equal to deltaShift.
%
%   Usage:  shifts = shiftsGrid(deltaShift)
%
%   Input:
%
%   deltaShift      :   the distance desired.
%
%   Output:
%   shifts          :   an array containing the coordinates of the shifts.
%
%   Example:
%   We set the origin as 'X' and we want the separation-delta ('A') neighbors. 
%   If separation=3 we obtain the coordinates for the points marked as 'A':
%
%   A A A A A A A
%   A - - - - - A
%   A - - - - - A
%   A - - X - - A
%   A - - - - - A
%   A - - - - - A
%   A A A A A A A
%   
%   Each point marked as A is returned as a pair (X,Y).
%---------------------------------------------------------

shifts  = [];
for ii=-abs(deltaShift):abs(deltaShift)
  for iii=-abs(deltaShift):abs(deltaShift)
    if(max(abs(iii),abs(ii)) == deltaShift); shifts = [shifts; ii,iii]; end;
  end
end