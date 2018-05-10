function [aoa_packet_data,tof_packet_data,output_top_aoas] = get_aoa_and_real_angle(filepath)
    if nargin < 1
        filepath='data/90.dat';
    end
    data_name = ' - ';
    antenna_distance = 0.06;
    frequency = 5.825 * 10^9;
    sub_freq_delta = (20 * 10^6) /30;
    
    csi_trace = readfile(filepath);
    num_packets = floor(length(csi_trace)/1);
    sampled_csi_trace = csi_sampling(csi_trace, num_packets, 1, length(csi_trace));
    
    num_packets = length(sampled_csi_trace);
    aoa_packet_data = cell(num_packets, 1);
    tof_packet_data = cell(num_packets, 1);
    
    [b,a]=butter(3,0.6,'low');
    parfor (i = 1:500,4)
    % for i = 1:50
        csi_entry = csi_trace{i};
        csi = get_scaled_csi(csi_entry);
        csi = csi(1, :, :);
        csi = squeeze(csi);
        csi = filter(b,a,csi);

        sanitized_csi = spotfi_algorithm_1(csi, sub_freq_delta);
        smoothed_sanitized_csi = smooth_csi(sanitized_csi);
        [aoa_packet_data{i}, tof_packet_data{i}] = aoa_tof_music(smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta, data_name);
        disp(i);
    end
    disp('Completeed: Music algorithm for every packet.');
    l = 0;
    for packet_index = 1:num_packets
        tof_matrix = tof_packet_data{packet_index};
        aoa_matrix = aoa_packet_data{packet_index};
        % AoA Loop
        for j = 1:size(aoa_matrix, 1)
            if tof_matrix(j, 1) <= 0
                break;
            end
            l = l + 1;
            full_measurement_matrix(l,1) = aoa_matrix(j, 1);
            full_measurement_matrix(l,2) = tof_matrix(j, 1);
        end
    end
    disp('Completeed: build a 2 column matrix of aoa and tof finished.');
    % tmp = sort(full_measurement_matrix(:,1));
    % scatter(1:size(tmp,1),tmp);
    aoa_max = max(abs(full_measurement_matrix(:, 1)));
    tof_max = max(abs(full_measurement_matrix(:, 2)));
    full_measurement_matrix(:, 1) = full_measurement_matrix(:, 1) / aoa_max;
    full_measurement_matrix(:, 2) = full_measurement_matrix(:, 2) / tof_max;
    % write_to_file(full_measurement_matrix,aoa_max,tof_max)
    % scatter(full_measurement_matrix(:,1),full_measurement_matrix(:,2))
    [cluster_indices,clusters] = aoa_tof_cluster(full_measurement_matrix);
    % data_cluster = clusters_find(clusters);
    % pair_of_aoa_tof = full_measurement_matrix;
    vari = cluster_weight(clusters,aoa_max,tof_max);
    % clusters_write_to_file(vari);
    disp('Completeed: cluster generation.');
    
    
    % weight_num_cluster_points = 0.0001 * 10^-3;
    % weight_aoa_variance = -0.7498 * 10^-3;
    % weight_tof_variance = 0.0441 * 10^-3;
    % weight_tof_mean = -0.0474 * 10^-3;
    % constant_offset = -1;

    output_top_aoas = likelihood(cluster_weight(clusters,aoa_max,tof_max))
    disp('Completeed: calculation of likelihood for every path.');
    disp('Completeed: All project.');
end