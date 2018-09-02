function [aoa_packet_data, tof_packet_data] = get_aoa_tof_pair(csi_filepath, counts_packets, antenna_distance, frequency, sub_freq_delta)
    fprintf('Phase 2: Get AoA ToF Pair\nStart:\n');
    pause(3);
    csi_trace = readfile(csi_filepath);
    num_packets = floor(length(csi_trace)/1);
    csi_trace = csi_sampling(csi_trace, num_packets, 1, length(csi_trace));
    data_name = '-';
    
    num_packets = counts_packets;
    aoa_packet_data = cell(num_packets, 1);
    tof_packet_data = cell(num_packets, 1);
    
    [b,a]=butter(3,0.6,'low');
    
    if num_packets <= 10
        for i = 1:num_packets
            csi_entry = csi_trace{i};
            csi = get_scaled_csi(csi_entry);
            snr = db(get_eff_SNRs(csi), 'pow');
            csi = csi(1, :, :);
            csi = squeeze(csi);
            csi = filter(b,a,csi);
            sanitized_csi = spotfi_algorithm_1(csi, sub_freq_delta);
            smoothed_sanitized_csi = smooth_csi(sanitized_csi);
            [aoa_packet_data{i}, tof_packet_data{i}] = aoa_tof_music_origin(smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta, snr(1,:), data_name);
            disp(i);
        end
    else
        parfor (i = 1:num_packets,4)
            csi_entry = csi_trace{i};
            csi = get_scaled_csi(csi_entry);
            snr = db(get_eff_SNRs(csi), 'pow');
            csi = csi(1, :, :);
            csi = squeeze(csi);
            csi = filter(b,a,csi);
            sanitized_csi = spotfi_algorithm_1(csi, sub_freq_delta);
            smoothed_sanitized_csi = smooth_csi(sanitized_csi);
            [aoa_packet_data{i}, tof_packet_data{i}] = aoa_tof_music(smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta, snr(1,:), data_name);
            disp(i);
        end
    end
    fprintf('Phase 2 Finished.\n');
    pause(1);
end
