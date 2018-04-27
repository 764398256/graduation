%
%  功能：消除STO对数据的影响
%  参数表：csi_matrix -> 待处理的csi矩阵, delta_f -> 相邻子载波的频率差, packet_one_phase_matrix -> 每个数据第一个数据包的csi矩阵
%  输出：csi_matrix -> 完成处理的csi矩阵, phase_matrix -> 需要修改的相位差矩阵
%  简介：通过线性拟合找到tau值，然后根据公式计算相位差，最后合并
%
function [csi_matrix, phase_matrix] = spotfi_algorithm_1(csi_matrix, delta_f, packet_one_phase_matrix)
    % 解卷绕
    R = abs(csi_matrix);
    phase_matrix = unwrap(angle(csi_matrix), pi, 2);
    tmp = csi_matrix;
    % 参数处理
    if nargin < 3
        packet_one_phase_matrix = phase_matrix;
    end
    % 代替论文中的算式，用图形求出tau
    fit_X(1:30, 1) = 1:1:30;
    fit_X(31:60, 1) = 1:1:30;
    fit_X(61:90, 1) = 1:1:30;
    fit_Y = zeros(90, 1);
    for i = 1:size(phase_matrix, 1)% 行
        for j = 1:size(phase_matrix, 2)% 列
            fit_Y((i - 1) * 30 + j) = packet_one_phase_matrix(i, j);
        end
    end
    result = polyfit(fit_X, fit_Y, 1);
    tau = result(1);
    % 对每一个数据进行去除tau（STO）操作
    for m = 1:size(phase_matrix, 1)
        for n = 1:size(phase_matrix, 2)
            %  Subtract the phase added from sampling time offset (STO)
            phase_matrix(m, n) = packet_one_phase_matrix(m, n) + (2 * pi * delta_f * (n - 1) * tau);
        end
    end
    % ？？？
    csi_matrix = R .* exp(1i * phase_matrix);
    disp('test')
end
