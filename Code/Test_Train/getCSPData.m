function cspData = getCSPData(testData, Wcsp, TFInfo, validRank, opt)
%% 小波滤波

wvdecData = testData;

% if opt.isWaveletDec250Hz
%     tic;
%     curData = zeros(size(testData));
%     for j = 1:size(testData,1)
%         curData(j,:) = wvdec(testData(j,:));
%     end
%     wvdecData = curData;    % ChxN
%     disp(['DWT. Time: ' num2str(toc) 's']);
% 
% end

%% C & F & T
nBlock = size(Wcsp,2);
% cspData = zeros([4*numel(Wcsp{1,1}) size(Wcsp)]);
for iValidRank = 1:numel(validRank)
    iTF = validRank(iValidRank);
    data = wvdecData(TFInfo{iTF}.SelCh,:)'; % NxCh
    data = filtfilt(TFInfo{iTF}.Fb,TFInfo{iTF}.Fa,data);    % NxCh
    cftsData = data(TFInfo{iTF}.TBand(1):TFInfo{iTF}.TBand(2),:);   % NxCh
    for iBlock = 1:nBlock
        LinkVarMatTest = [];
        for iChoose = 1:numel(Wcsp{iTF,iBlock})
            cspDataTmp = Wcsp{iTF,iBlock}{iChoose}'*cftsData'; % 4*N
            cspDataTmp = -log(var(cspDataTmp, 0, 2)'./sum(var(cspDataTmp, 0, 2)));    % 4*1
            cspDataTmp = cspDataTmp(:);
            LinkVarMatTest = cat(1, LinkVarMatTest, cspDataTmp);
        end
%         cspRawData = Wcsp{iTF,iBlock}{1}'*cftsData'; % 4*N
        cspData(:, iTF, iBlock) = LinkVarMatTest;    % 24*1
    end
end

end

