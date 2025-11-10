function RngMat = addRngMat(stPoint, wndWidth, endPoint, noverlap, RngMat)
for iT = stPoint:noverlap:endPoint
    if(iT+wndWidth-1 < endPoint)
%         iCnt = iCnt + 1;
        Rng = [iT, iT+wndWidth-1];
        RngMat = [RngMat; Rng];

    elseif iT+wndWidth-1 >= endPoint
%         iCnt = iCnt + 1;
        Rng = [endPoint-wndWidth+1, endPoint];
        RngMat = [RngMat; Rng];
        if iT+wndWidth-1 >= endPoint
            break;
        end
    else
        break;
    end
end
end