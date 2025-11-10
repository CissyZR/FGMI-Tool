function [FreqMat, iCnt] = GetFreqBands(stFreq, freqWidth, endFreq, FreqMat)


for iband = 1:length(freqWidth)
    noverlap = freqWidth(iband)/2;
    for iHz = stFreq:noverlap:endFreq
        if(iHz+freqWidth(iband) < endFreq)
            Rng = [iHz, iHz+freqWidth(iband)];
            FreqMat = [FreqMat; Rng];
        else
            break;
        end
    end

end
iCnt = size(FreqMat, 1);


