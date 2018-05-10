%
%  功能：MUSIC算法
%  参数表：x -> csi矩阵, antenna_distance -> 天线间距, frequency -> 载波传送频率, sub_freq_delta -> 相邻子载波频率差, data_name -> 不明
%  输出：estimated_aoas -> 评估的来波角度, estimated_tofs -> 评估的飞行时间
%  简介：不解释
%
function [estimated_aoas, estimated_tofs] = aoa_tof_music(x, antenna_distance, frequency, sub_freq_delta, data_name)
    % 参数处理
    if nargin == 4
        data_name = '-';
    end
    % 特征向量组成的矩阵
    eigenvectors = noise_space_eigenvectors(x);
    % 角度范围，飞行时间范围
    theta = -90:1:90;
    tau = 0:(1.0 * 10^-9):(100 * 10^-9);
    % MUSIC算法，返回每个csi数据在每个角度，每个飞行时间的计算结果
    Pmusic = music_spectrum(theta,tau,frequency, sub_freq_delta, antenna_distance,eigenvectors);
    % 选出所有疑似值并返回
    [estimated_aoas, estimated_tofs] = find_music_peaks(Pmusic,theta,tau);
    % 画图
    % [x,y] = meshgrid(theta, tau);
    % figure(1);
    % mesh(x,y,Pmusic');
    % xlabel('AoA');
    % ylabel('ToF');
    % xlim([-90 90]);
    % colorbar;
end
