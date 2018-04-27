%
%  功能：画出输入csi数据的MUSIC算法结果
%  参数表：filepath -> csi数据所在的相对路径
%  输出：无
%  简介：对输入的csi数据进行一次MUSIC算法，画出结果
%
function plot_Pmusic(filepath)
    % 常量
    antenna_distance = 0.06;
    frequency = 5.825 * 10^9;
    sub_freq_delta = (20 * 10^6) /30;
    % 数据读取
    csi_trace = readfile(filepath);
    % 抽取一个数据样本
    chose_one = floor(length(csi_trace)/2);
    csi_entry = csi_trace{chose_one};
    % 数据处理
    csi = get_scaled_csi(csi_entry);
    csi = csi(1, :, :);
    csi = squeeze(csi);
    smoothed_sanitized_csi = smooth_csi(csi);
    eigenvectors = noise_space_eigenvectors(smoothed_sanitized_csi);
    theta = -90:1:90;
    tau = 0:(100.0 * 10^-9):(3000 * 10^-9);
    % 计算
    Pmusic = music_spectrum(theta,tau,frequency, sub_freq_delta, antenna_distance,eigenvectors);
    % 画图
    [x,y] = meshgrid(theta, tau);
    subplot(2,1,1);
    mesh(x,y,Pmusic');
    xlabel('AoA');
    ylabel('ToF');
    xlim([-90 90]);
    colorbar;
    hold on;
    subplot(2,1,2);
    mesh(x,y,Pmusic');
    view(2);
    xlabel('AoA');
    ylabel('ToF');
    xlim([-90 90]);
    colorbar;
    hold on;
end
