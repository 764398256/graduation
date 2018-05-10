%   ->
%  功能：计算特征向量
%  参数表：x -> 经过smooth处理后的csi矩阵
%  输出：eigenvectors -> 特征向量组
%  简介：此算法是MUSIC算法的一部分，根据矩阵数据得出特征向量组。一部分是数据，另一部分是噪声，因为MUSIC的输入必须是方阵，所以才有上一步的smooth_csi后的x矩阵
%
function eigenvectors = noise_space_eigenvectors(x)
    % 来自学长
    % 入射信号个数
    signal_N = 1;
    % 表示天线个数有3个，相当于阵列信号中的阵列个数
    array_N = 3;
    % 副载波个数
    carrier_N = 30;
    % 天线阵列间距与波长比值，阵列间距取6cm比较合适，对应这里是0.5
    ratio = 0.5;
    % 计算协方差矩阵作为MUSIC算法输入
    R = x * x';
    % 计算特征向量
    [V,D]=eig(R);
    % diag(D):提取对角数据得到一维向量; sort(D):对向量从小到大排序
    [D,I]=sort(diag(D));
    eigenvectors = V(:,I(1:array_N - signal_N));
end
