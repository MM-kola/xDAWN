% %% xDAWN算法实现
% % x = D*A*W+N
% % 构造D矩阵
% % x的QR分解：x=Qx*Rx
% % 这里的Rx矩阵是上三角矩阵，取上三角部分构成方阵。
% % D的QR分解：D=Qd*Rd
% % 记M为Qd'*Qx，计算M的svd分解SVD
% % 取u与v的前3列
% % W = inv(Rx)*Si; 
% % A = inv(Rd)*Ui*Vi;
% % S = x*W
% %%test
% clc;
% clear all;
% close all;
% signal = rand(100,64);
% [outSignal,W,A]=xDAWN(signal,100,0,1,0.2,0.4,0.5,20);
%% xDAWN
% parameters：
%    'f'    ：信号的采样频率
%'starttime'：起始时间点对应刺激的相对时间
% 'endtime' ：结束时间点对应刺激的相应时间
%    'p'    ：Ti的起始时间
%    't'    ：Ti的持续时间
%    'Ne'   ：evoke的观测时间
%    'n'    ：主n个成分
% out：
% 'outSignal'：滤波后的信号
%    'W'    ：空间滤波器
%    'A'    ：预测的evoke信号
function [outSignal,W,A]=xDAWN(signal,f,starttime,endtime,p,t,Ne,n)
% N个值作为特征值
N = n;
% signal = rand(100,64);%采样频率100
x = signal;
%计算x的qr分解
[Qx,Rx]=qr(x,0);
% D = createD(100,0,1,0.2,0.4,0.5);
D = createD(f,starttime,endtime,p,t,Ne);
%计算D的qr分解
[Qd,Rd]=qr(D,0);
M = Qd'*Qx;
% M做svd后特征值本身就是降序
[U,V,S]=svd(M);
% 取前n个值作为特征值
Ui = U(:,1:N);
Si = S(:,1:N);
Vi = V(1:N,1:N);
% 计算滤波器W和估计evoke信号A
% W = Rx'*Si;文献中有错误
W = inv(Rx)*Si;
A = inv(Rd)*Ui*Vi;
% 计算滤波后的输出信号
outSignal = x*W;
end
%% 构造D矩阵
% parameters：
%    'f'    ：信号的采样频率
%'starttime'：起始时间点对应刺激的相对时间
% 'endtime' ：结束时间点对应刺激的相应时间
%    'p'    ：Ti的起始时间
%    't'    ：Ti的持续时间
%    'Ne'   ：evoke的观测时间
% out：
%    'D'    ：构造的D矩阵
function [D] = createD(f,starttime,endtime,p,t,Ne)
len = (endtime-starttime)*f;
tStart = p*f;
tEnd = tStart+t*f;
firstColumn = zeros(1,len);
for i=1:len
    if i>=tStart&&i<=tEnd
        firstColumn(i) = 1;
    end
end
%构造托普利兹矩阵D
D = zeros(len,Ne*f);
D(:,1)=firstColumn';
for j=2:Ne*f
   for i=2:len
     D(i,j) = D(i-1,j-1);
   end
end
end

