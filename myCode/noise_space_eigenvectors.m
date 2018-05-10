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
    % figure
    % subplot(1,2,1)
    % plot(abs(D)/max(abs(D)),'r-'),grid on
    % xlabel('number of eigenvalube')
    % ylabel('eigenvalube')
    % 前面对D进行按照升序排列了，这里选择最小的几个（对应的是噪声）
    % 只有1个目标点，因此这里是1:N-1  如果对2个目标点定位，则这里是1:N-2

    v=V(:,I(1:array_N - signal_N));
    eigenvectors = v;

    % theta=-90:1:90; %linspace(-pi/2,pi/2,180); %½« -pi/2 µ½ pi/2
    % for jj=1:length(theta)
    %    a=exp(j*2*pi*ratio*sin(theta(jj)*pi/180)*[0:array_N-1]');
    %    s(jj)=1/(a' * v * v' * a);
    %end
    % subplot(1,2,2)
    % plot(theta,abs(s)),grid on
    % xlabel('theta/degree')
    % ylabel('power of MUSIC method')

    %-% MUSIC算法中必要的一步，矩阵x及其共轭转置矩阵的乘积R
    %-R = x * x';
    %-% 对R求特征向量组
    %-[eigenvectors, eigenvalue_matrix] = eig(R);
    %-% 对特征值进行单位化操作
    %-max_eigenvalue = -1111;
    %-for ii = 1:size(eigenvalue_matrix, 1)
    %-    if eigenvalue_matrix(ii, ii) > max_eigenvalue
    %-        max_eigenvalue = eigenvalue_matrix(ii, ii);
    %-    end
    %-end
    %-for ii = 1:size(eigenvalue_matrix, 1)
    %-    eigenvalue_matrix(ii, ii) = eigenvalue_matrix(ii, ii) / max_eigenvalue;
    %-end
    %-
    %-% 抽取一部分作为参与计算的噪声部分
    %-start_index = size(eigenvalue_matrix, 1) - 2;
    %-end_index = start_index - 10;
    %-decrease_ratios = zeros(start_index - end_index + 1, 1);
    %-k = 1;
    %-for ii = start_index:-1:end_index
    %-    temp_decrease_ratio = eigenvalue_matrix(ii + 1, ii + 1) / eigenvalue_matrix(ii, ii);
    %-    decrease_ratios(k, 1) = temp_decrease_ratio;
    %-    k = k + 1;
    %-end
    %-[max_decrease_ratio, max_decrease_ratio_index] = max(decrease_ratios);
    %-index_in_eigenvalues = size(eigenvalue_matrix, 1) - max_decrease_ratio_index;
    %-num_computed_paths = size(eigenvalue_matrix, 1) - index_in_eigenvalues + 1;
    %-
    %-% Estimate noise subspace
    %-column_indices = 1:(size(eigenvalue_matrix, 1) - num_computed_paths);
    %-eigenvectors = eigenvectors(:, column_indices);
end
