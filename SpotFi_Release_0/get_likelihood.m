%   ->
%  功能：
%  参数表：clusters_struct -> 信息齐全的聚类表
%  输出：result -> 前5个最有可能是正确答案的aoa，tof组合
%  简介：根据论文公式进行计算
%
function result = get_likelihood(clusters_struct)
    % 参数，返回值预设
    length = size(clusters_struct,2);
    tmp = zeros(length,2);
    likehood_index = [1,1,1,1,1];
    result = zeros(5,2);
    % 计算所有likelihood
    for i=1:length
        tmp(i,2) = clusters_struct(i).aoa_mean;
        weight_num_cluster_points = 1e-2;
        weight_aoa_variance = -8e-2;
        weight_tof_variance = -1e17;
        weight_tof_mean = -10e8;
        tmp(i,1) = ...
            weight_num_cluster_points * clusters_struct(i).point_num ...
            + weight_aoa_variance * clusters_struct(i).aoa_var ...
            + weight_tof_variance * clusters_struct(i).tof_var ...
            + weight_tof_mean * clusters_struct(i).tof_mean;
    end
    % 找到前五个likelihood最大的组合编号
    for i = 1:size(tmp)
        flag = tmp(i,1);
        for j = 1:5
            if flag > tmp(likehood_index(j))
                for k = 5:-1:j+1
                    likehood_index(k) = likehood_index(k-1)
                end
                likehood_index(j) = i;
                break;
            end
        end
    end
    % 抽出前五个
    for i=1:5
        result(i,1) = clusters_struct(likehood_index(i)).aoa_mean;
        result(i,2) = clusters_struct(likehood_index(i)).tof_mean;
    end
end
