function [TrainData, TrainLabel, TestData, TestLabel] = LoadData(FilePath)
    TrainData = load(FilePath).TrainData;
    TrainLabel = load(FilePath).TrainLabel;
    TestData = load(FilePath).TestData;
    TestLabel = load(FilePath).TestLabel;
end

