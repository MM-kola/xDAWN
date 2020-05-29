clear;
clc;
close all;
%% 载入p300真例数据
% 格式说明：
% 采样频率：240hz
% 持续时间：0s - 0.65s
filename='map_64x156';
K=0;
if K == 1
  data=load([filename '\true\True_Map1.mat']); data=data.TrueData_map;
else
  data=load([filename '\false\False_Map1.mat']); data=data.FalseData_map;
end
test_signal = data(:,:,4);
[smoothSignal,filtwts] = eegfilter(test_signal,240,4,8,3);
save('Osignal','test_signal','-v7.3' );
save('Fsignal','smoothSignal','-v7.3' );
%% xDAWN滤波
test_signal = test_signal';
smoothSignal = smoothSignal';
signal = test_signal;
[outSignal1,W1,A1]=xDAWN(signal,240,0,0.65,0.2,0,0.4,4);
signal = smoothSignal;
[outSignal2,W2,A2]=xDAWN(signal,240,0,0.65,0.2,0,0.4,4);
%% 保存处理后的信号
save('X_signal_A','outSignal1','-v7.3' );
save('A_evoke_A','A1','-v7.3' );
save('X_signal_F','outSignal2','-v7.3' );
save('A_evoke_F','A2','-v7.3' );
fprintf('ALL DOWN!!!\r')



