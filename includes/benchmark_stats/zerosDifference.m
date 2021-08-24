function [dTot, diff_B_A, zerosAInBoxRemaining, unmatchedzerosBA, zerosAInBoxRemainingList] = zerosDifference(zerosAind, zRealA, zImagA, zerosBind, zRealB, zImagB, tolD, sizeBox)
%zerosDifference  Compute the difference of two zero sets as in Section 5.4.
%                 The output variable dTot is the number of elements in the sets appearing in Eq. (5.14)
%                 where the inclusions in U and \phi(U) do not hold.
%                 Here we consider two zero sets A and B, which in the manuscript are referred as:
%                 A <-> \hat{Z}_r^{\delta_{Lo}} \cap \Omega_{(L-1)-2 \delta_{\mathrm{Lo}}}
%                 B <-> \tilde{Z}_r^{\delta_{Hi}}.
%
%   Usage:  [dTot, diff_B_A, zerosAInBoxRemaining] = zerosDifference(zerosAind, zRealA, zImagA, zerosBind, zRealB, zImagB, tolD, sizeBox)
%
%   Input:
%
%   zerosAind               :   an array containing the set of zeros captured with a target resolution.
%   zRealA                  :   an array containing the real coordinates to interpret zerosAind in the complex plane.
%   zImagA                  :   an array containing the imaginary coordinates to interpret zerosAind in the complex plane.
%   zerosBind               :   an array containing the set of reference zeros.
%   zRealB                  :   an array containing the real coordinates to interpret zerosBind in the complex plane.
%   zImagB                  :   an array containing the imaginary coordinates to interpret zerosBind in the complex plane.
%   tolD                    :   a parameter indicating the tolerance in number of \delta's when matching zeros of B with those of A.
%   sizeBox                 :   only the zeros in [-sizeBox, sizeBox] x [-sizeBox, sizeBox] are matched between sets.
%
%   Output:
%   dTot                    :   total number of unmatched zeros.
%   diff_B_A                :   number of unmatched elements in B.
%   zerosAInBoxRemaining    :   number of unmatched elements of A on a target square centered at the origin.
%
%---------------------------------------------------------  

deltaA = zRealA(2)-zRealA(1);
deltaB = zRealB(2)-zRealB(1);

if(deltaA < deltaB)
    error('A should have resolution lower or equal to that of B.');
end
 
unmatchedzerosBA = [];

rowsA = length(zRealA);
colsA = length(zImagA);

rowsB = length(zRealB);
colsB = length(zImagB);

[zerosAXsubind, zerosAYsubind] = ind2sub([rowsA, colsA], zerosAind);
[zerosBXsubind, zerosBYsubind] = ind2sub([rowsB, colsB], zerosBind);

zerosAXK = zRealA(zerosAXsubind);
zerosAYK = zImagA(zerosAYsubind);
zerosBXK = zRealB(zerosBXsubind);
zerosBYK = zImagB(zerosBYsubind);
 
zerosBInBox = zerosBox(zerosBXK, zerosBYK, sizeBox, deltaB);

diff_B_A  = 0;

for ii=1:length(zerosBInBox)
    distSelectedZeroBA                    = max(abs(zerosBXK(zerosBInBox(ii))-zerosAXK), abs(zerosBYK(zerosBInBox(ii))-zerosAYK));
    candidates                            = find(distSelectedZeroBA <= tolD*deltaA);
    if(length(candidates) > 0)
        closestPointsAmongCandidates      = find(distSelectedZeroBA(candidates) == min(distSelectedZeroBA(candidates)));
        indexMappedZeroInA                = candidates(closestPointsAmongCandidates(1));
        zerosAXK(indexMappedZeroInA)      = [];
        zerosAYK(indexMappedZeroInA)      = [];
        zerosAXsubind(indexMappedZeroInA) = [];
        zerosAYsubind(indexMappedZeroInA) = [];
        zerosAind(indexMappedZeroInA)     = [];
    else
        diff_B_A                          = diff_B_A + 1;
        unmatchedzerosBA                  = [unmatchedzerosBA, [zerosBXK(zerosBInBox(ii)); zerosBYK(zerosBInBox(ii))]];
    end
end

zerosAInBoxRemaining        = countInCentralBox(zerosAXK, zerosAYK, sizeBox - 2*deltaA, deltaA);
zerosAInBoxRemainingList    = [zerosAXK(zerosBox(zerosAXK, zerosAYK, sizeBox - 2*deltaA, deltaA)); zerosAYK(zerosBox(zerosAXK, zerosAYK, sizeBox - 2*deltaA, deltaA))];

dTot                 = diff_B_A + zerosAInBoxRemaining;