%
%  功能：把数据处理成MUSIC适用格式
%  参数表：csi -> 待处理的csi矩阵
%  输出：smoothed_csi -> 完成处理的csi矩阵
%  简介：按照固定格式，把矩阵大小从3x30变成30x30
%
function smoothed_csi = smooth_csi(csi)
    half_of_rank = 14;
    start_of_row = [1,16];
    start_of_col = [1,16];
    step = [1:1:15];
    smoothed_csi = zeros(size(csi, 2), size(csi, 2));
    % 左上角部分
    m = start_of_row(1);
    for ii = step
        n = start_of_col(1);
        for j = ii:1:(ii + half_of_rank)
            smoothed_csi(m, n) = csi(1, j);
            n = n + 1;
        end
        m = m + 1;
    end
    % 右上角部分
    m = start_of_row(2);
    for ii = step
        n = start_of_col(1);
        for j = ii:1:(ii + half_of_rank)
            smoothed_csi(m, n) = csi(2, j);
            n = n + 1;
        end
        m = m + 1;
    end
    % 左下角部分
    m = start_of_row(1);
    for ii = step
        n = start_of_col(2);
        for j = ii:1:(ii + half_of_rank)
            smoothed_csi(m, n) = csi(2, j);
            n = n + 1;
        end
        m = m + 1;
    end
    % 右下角部分
    m = start_of_row(2);
    for ii = step
        n = start_of_col(2);
        for j = ii:1:(ii + half_of_rank)
            smoothed_csi(m, n) = csi(3, j);
            n = n + 1;
        end
        m = m + 1;
    end
end
