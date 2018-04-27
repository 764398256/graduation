function [aoa_packet_data,tof_packet_data,output_top_aoas] = test(filepath)
    if nargin < 1
        filepath='data/test.dat';
    end
    antenna_distance = 0.06;
    frequency = 5.825 * 10^9;
    sub_freq_delta = (20 * 10^6) /30;
    
    csi_trace = readfile(filepath);
    num_packets = floor(length(csi_trace)/1);
    sampled_csi_trace = csi_sampling(csi_trace, num_packets, 1, length(csi_trace));
    [aoa_packet_data,tof_packet_data,output_top_aoas] = spotfi(sampled_csi_trace, frequency, sub_freq_delta, antenna_distance);
end

function [aoa_packet_data,tof_packet_data,output_top_aoas] = spotfi(csi_trace, frequency, sub_freq_delta, antenna_distance, data_name)
    % 参数处理
	if nargin < 5
        data_name = ' - ';
    end
	% 包的数量
    num_packets = length(csi_trace);
    % 预设返回值
    aoa_packet_data = cell(num_packets, 1);
    tof_packet_data = cell(num_packets, 1);
    packet_one_phase_matrix = 0;
	% 抽取第一个包数据，作为比较基准
    csi_entry = csi_trace{1};
    csi = get_scaled_csi(csi_entry);
    % 只考虑第一根天线
    csi = csi(1, :, :);
    % 降维
    csi = squeeze(csi);

    % 对第一个包进行MUSIC前的处理
	% 论文中的Algorithm 1
    packet_one_phase_matrix = unwrap(angle(csi), pi, 2);
    sanitized_csi = spotfi_algorithm_1(csi, sub_freq_delta);
    % smoothed CSI matrix
    smoothed_sanitized_csi = smooth_csi(sanitized_csi);
    % Run SpotFi's AoA-ToF MUSIC algorithm on the smoothed and sanitized CSI matrix
    [aoa_packet_data{1}, tof_packet_data{1}] = aoa_tof_music(smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta, data_name);
    fprintf('1\n');

    % TODO: REMEMBER THIS IS A PARFOR LOOP, AND YOU CHANGED THE ABOVE CODE AND THE BEGIN INDEX
    % 以第一个包为基准，对其余的包进行同样的处理
	parfor (packet_index = 2:num_packets, 4)
        % Get CSI for current packet
        csi_entry = csi_trace{packet_index};
        csi = get_scaled_csi(csi_entry);
        % Only consider measurements for transmitting on one antenna
        csi = csi(1, :, :);
        % Remove the single element dimension
        csi = squeeze(csi);

        % Sanitize ToFs with Algorithm 1
        sanitized_csi = spotfi_algorithm_1(csi, sub_freq_delta, packet_one_phase_matrix);

        % Acquire smoothed CSI matrix
        smoothed_sanitized_csi = smooth_csi(sanitized_csi);
        % Run SpotFi's AoA-ToF MUSIC algorithm on the smoothed and sanitized CSI matrix
        [aoa_packet_data{packet_index}, tof_packet_data{packet_index}] = aoa_tof_music(smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta, data_name);
        fprintf('%d\n',packet_index);
    end
    
    output_top_aoas=['test']
end