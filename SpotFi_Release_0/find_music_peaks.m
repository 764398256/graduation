%
%  功能：寻找波峰
%  参数表：Pmusic -> 待测矩阵,theta -> aoa范围,tau -> tof范围
%  输出：estimated_aoas -> 预测来波角度, estimated_tofs -> 预测飞行时间
%  简介：MUSIC算法在计算完毕之后，通过得到的结果中的波峰来预测来波角度
%
function [estimated_aoas, estimated_tofs] = find_music_peaks(Pmusic,theta,tau)
    % 在MUSIC计算结果中的第一列寻找aoa波峰并抽出
    [~, aoa_peak_indices] = findpeaks(Pmusic(:, 1));
    estimated_aoas = theta(aoa_peak_indices);
    % 预设tof返回值
    time_peak_indices = zeros(length(aoa_peak_indices), length(tau));
    % AoA loop (only looping over peaks in AoA found above)
    for ii = 1:length(aoa_peak_indices)
        aoa_index = aoa_peak_indices(ii);
        % For each AoA, find ToF peaks
        [peak_values, tof_peak_indices] = findpeaks(Pmusic(aoa_index, :));
        if isempty(tof_peak_indices)
            tof_peak_indices = 1;
        end
        negative_ones_for_padding = -1 * ones(1, length(tau) - length(tof_peak_indices));
        time_peak_indices(ii, :) = horzcat(tau(tof_peak_indices), negative_ones_for_padding);
    end

    % Set return values
    % AoA is now a column vector
    estimated_aoas = transpose(estimated_aoas);
    % ToF is now a length(estimated_aoas) x length(tau) matrix, with -1 padding for unused cells
    estimated_tofs = time_peak_indices(:,1);
end
