function [test_aoa_packet_0,test_aoa_packet_1,test_aoa_packet_2] = get_aoa_tof_pair_test(csi_filepath, counts_packets, antenna_distance, frequency, sub_freq_delta)
    fprintf('Phase 2: Get AoA ToF Pair\nStart:\n');
    csi_trace = readfile(csi_filepath);
    num_packets = floor(length(csi_trace)/1);
    csi_trace = csi_sampling(csi_trace, num_packets, 1, length(csi_trace));
    data_name = '-';
    
    num_packets = counts_packets;
    test_aoa_packet_0 = cell(10, 1);
    test_aoa_packet_1 = cell(10, 1);
    test_aoa_packet_2 = cell(10, 1);
    
    [b,a]=butter(3,0.6,'low');

    for i = 1:10
        csi_entry = csi_trace{i};
        csi = get_scaled_csi(csi_entry);
        csi = csi(1, :, :);
        csi = squeeze(csi);
        csi = filter(b,a,csi);
        sanitized_csi = spotfi_algorithm_1(csi, sub_freq_delta);
        smoothed_sanitized_csi = smooth_csi(sanitized_csi);
        [test_aoa_packet_0{i}, test_aoa_packet_1{i},test_aoa_packet_2{i}] = music_aoa_test(smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta, data_name);
        disp(i);
    end
    fprintf('Phase 2 Finished.\n');
end
