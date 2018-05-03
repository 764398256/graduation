%   ->
%  功能：计算特征向�?
%  参数表：x -> 经过smooth处理后的csi矩阵
%  输出：eigenvectors -> 特征向量�?
%  �?介：此算法是MUSIC算法的一部分，根据矩阵数据得出特征向量组。一部分是数据，�?部分是噪声�?�因为MUSIC的输入必须是方阵，所以才有上�?步的smooth_csi后的x矩阵
%
function eigenvectors = noise_space_eigenvectors(x)
    % MUSIC算法中必要的�?步，矩阵x及其共轭转置矩阵的乘积R
    R = x * x';
    % 对R求特征向量组
    [eigenvectors, eigenvalue_matrix] = eig(R);
    % 对特征�?�进行单位化操作
    max_eigenvalue = -1111;
    for ii = 1:size(eigenvalue_matrix, 1)
        if eigenvalue_matrix(ii, ii) > max_eigenvalue
            max_eigenvalue = eigenvalue_matrix(ii, ii);
        end
    end
    for ii = 1:size(eigenvalue_matrix, 1)
        eigenvalue_matrix(ii, ii) = eigenvalue_matrix(ii, ii) / max_eigenvalue;
    end

    % 抽取�?部分作为参与计算的噪声部�?
    start_index = size(eigenvalue_matrix, 1) - 2;
    end_index = start_index - 10;
    decrease_ratios = zeros(start_index - end_index + 1, 1);
    k = 1;
    for ii = start_index:-1:end_index
        temp_decrease_ratio = eigenvalue_matrix(ii + 1, ii + 1) / eigenvalue_matrix(ii, ii);
        decrease_ratios(k, 1) = temp_decrease_ratio;
        k = k + 1;
    end
    [max_decrease_ratio, max_decrease_ratio_index] = max(decrease_ratios);
    index_in_eigenvalues = size(eigenvalue_matrix, 1) - max_decrease_ratio_index;
    num_computed_paths = size(eigenvalue_matrix, 1) - index_in_eigenvalues + 1;

    % Estimate noise subspace
    column_indices = 1:(size(eigenvalue_matrix, 1) - num_computed_paths);
    eigenvectors = eigenvectors(:, column_indices);
end
