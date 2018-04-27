% 
%  功能：MUSIC算法本体
%  参数表：theta -> 来波角度范围,tau -> 飞行时间范围,frequency -> 载波频率, sub_freq_delta -> 相邻子载波频率差, antenna_distance -> 天线间距,eigenvectors -> 特征向量组
%  输出：Pmusic -> 计算结果矩阵
%  简介：不解释
%
function Pmusic = music_spectrum(theta,tau,frequency, sub_freq_delta, antenna_distance,eigenvectors)
    Pmusic = zeros(length(theta), length(tau));
    % Angle of Arrival Loop (AoA)
    for ii = 1:length(theta)
        % Time of Flight Loop (ToF)
        for jj = 1:length(tau)
            steering_vector = compute_steering_vector(theta(ii), tau(jj), ...
                    frequency, sub_freq_delta, antenna_distance);
            PP = steering_vector' * (eigenvectors * eigenvectors') * steering_vector;
            Pmusic(ii, jj) = abs(1 /  PP);
        end
    end

    % Convert to decibels转化为分贝，为计算
    % ToF loop
    for jj = 1:size(Pmusic, 2)
        % AoA loop
        for ii = 1:size(Pmusic, 1)
            Pmusic(ii, jj) = 10 * log10(Pmusic(ii, jj));% / max(Pmusic(:, jj)));
            Pmusic(ii, jj) = abs(Pmusic(ii, jj));
        end
    end
end

% 
%  功能：计算方向向量
%  参数表：theta -> 来波角度, tau -> 飞行时间, freq -> 载波频率, sub_freq_delta -> 相邻子载波频率差, ant_dist -> 天线间距
%  输出：steering_vector -> 方向向量
%  简介：公式
%
function steering_vector = compute_steering_vector(theta, tau, freq, sub_freq_delta, ant_dist)
    steering_vector = zeros(30, 1);
    k = 1;
    base_element = 1;
    for ii = 1:2
        for jj = 1:15
            steering_vector(k, 1) = base_element * omega_tof_phase(tau, sub_freq_delta)^(jj - 1);
            k = k + 1;
        end
        base_element = base_element * phi_aoa_phase(theta, freq, ant_dist);
    end
end

% 
%  功能：根据tof计算相位偏移
%  参数表：tau -> 飞行时间, sub_freq_delta -> 相邻子载波频率差
%  输出：time_phase -> 相位差
%  简介：公式
%
function time_phase = omega_tof_phase(tau, sub_freq_delta)
    time_phase = exp(-1i * 2 * pi * sub_freq_delta * tau);
end

% 
%  功能：根据来波角度计算相位偏移
%  参数表：theta -> 来波角度, frequency -> 载波频率, d -> 天线间距
%  输出：angle_phase -> 相位差
%  简介：公式
%
function angle_phase = phi_aoa_phase(theta, frequency, d)
    % Speed of light (in m/s)
    c = 3.0 * 10^8;
    % Convert to radians
    theta = theta / 180 * pi;
    angle_phase = exp(-1i * 2 * pi * d * sin(theta) * (frequency / c));
end
