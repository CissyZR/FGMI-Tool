function FCTData = getCFTSData(Data, CFTSInfo)
% Data Format: Trial x Ch x N

% Backup Data
Data_Trans = Data;

% C
Data_Trans = Data_Trans(:,CFTSInfo.SelCh,:);

% F
Data_Trans = permute(filtfilt(CFTSInfo.Fb, CFTSInfo.Fa, permute(Data_Trans, [3 2 1])), [3 2 1]);

% T
FCTData = Data_Trans(:,:,CFTSInfo.TBand(1):CFTSInfo.TBand(2));


end
