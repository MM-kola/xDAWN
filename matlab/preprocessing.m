clear;
clc;
close all;
%% 载入p300真例数据
% 格式说明：
% 采样频率：240hz
% 持续时间：0s - 0.65s
train_filename = 'G:\EEGNet\data\EEGDataset\SingleTaril\TrainDatas\Circle/TrainDataset.mat';
hold_filename = 'G:\EEGNet\data\EEGDataset\SingleTaril\TrainDatas\Circle/HoldDataset.mat';
train_data=load(train_filename); 
hold_data=load(hold_filename); 
train_signal=train_data.data;
train_label=train_data.label;

hold_signal=hold_data.data;
hold_label=hold_data.label;

train_n = size(train_label,1);
hold_n = size(hold_label,1);

train_preproc=zeros(size(train_signal,1),72,4);
hold_preproc=zeros(size(hold_signal,1),72,4);

for i=1:train_n
    test_signal(:,:) = train_signal(i,:,:);
    %滤波
    [smoothSignal,] = eegfilter(test_signal',120,4,16,3);
    outSignal1=smoothSignal';
    %xdawn
%     signal=test_signal(:,:);
    [outSignal1,W1,A1]=xDAWN(outSignal1,120,0,0.6,0.2,0,0.2,4);
%     outSignal1 =test_signal(:,:);
    for k=1:size(outSignal1,2)
        outSignal1(:,k)=zscore(outSignal1(:,k));
    end
    train_preproc(i,:,:) = outSignal1;
end
for i=1:hold_n
    test_signal(:,:) = hold_signal(i,:,:);
    %滤波
    [smoothSignal,] = eegfilter(test_signal',120,4,16,3);
    outSignal2=smoothSignal';
    %xdawn
%     signal=test_signal(:,:);
    [outSignal2,W2,A2]=xDAWN(outSignal2,120,0,0.6,0.2,0,0.2,4);
    
%     outSignal2 =test_signal(:,:);
    for k=1:size(outSignal2,2)
        outSignal2(:,k)=zscore(outSignal2(:,k));
    end
    hold_preproc(i,:,:) = outSignal2;
end
save('Train_preproc.mat','train_preproc','train_label' );
save('Hold_preproc.mat','hold_preproc','hold_label');
fprintf('all over!!\r')