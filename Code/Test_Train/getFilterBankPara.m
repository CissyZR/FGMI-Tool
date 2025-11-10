function filterBankPara = getFilterBankPara(opt)
N = 5;
reSAMP = opt.Fs;
RngMat = opt.FreqRngMat;
nBand = opt.nFBand;
for iBand = 1:nBand
    FreqRng = RngMat(iBand, :);
    W1=[2*FreqRng(1)/reSAMP 2*FreqRng(2)/reSAMP];
    [filterBankPara(iBand).b,filterBankPara(iBand).a]=butter(N,W1);   
%     [DataTrainCell{iBand}, DataTestCell{iBand}] = FilterBankProc(DataTrain, DataTest, RngMat(iBand, :), N, reSAMP);
end



