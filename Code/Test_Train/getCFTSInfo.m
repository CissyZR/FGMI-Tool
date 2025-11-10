function [CFTSInfoCell, nChSel, nFBand, nTBand] = getCFTSInfo(opt)
% Channel Selection Parameters
SelChCell = opt.SelChCell;
nChSel = numel(SelChCell);

% Filter Parameters
FreqRngMat = opt.FreqRngMat;
nFBand = opt.nFBand;
filterBankPara = opt.filterBankPara;

% Segment Parameters
TimeRngMat = opt.TimeRngMat;
nTBand = opt.nTBand;

% Initialization
CFTSInfoCell = cell(nChSel,nFBand,nTBand);

% tic;

for iSelCh = 1:nChSel
    for iBand = 1:nFBand
        for iSeg = 1:nTBand
            CFTSInfoCell{iSelCh,iBand,iSeg}.FBand = FreqRngMat(iBand,:);
            CFTSInfoCell{iSelCh,iBand,iSeg}.Fa = filterBankPara(iBand).a;
            CFTSInfoCell{iSelCh,iBand,iSeg}.Fb = filterBankPara(iBand).b;
            CFTSInfoCell{iSelCh,iBand,iSeg}.SelCh = SelChCell{iSelCh};
            CFTSInfoCell{iSelCh,iBand,iSeg}.TBand = TimeRngMat(iSeg,:);
        end
    end
end

end
