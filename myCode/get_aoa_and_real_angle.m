function [aoa_packet_data,tof_packet_data,output_top_aoas] = get_aoa_and_real_angle(filepath)
    if nargin < 1
        filepath='data/test2.dat';
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
    
    parfor (i = 40001:50000,4)
    % for i = 1:50
        csi_entry = csi_trace{i};
        csi = get_scaled_csi(csi_entry);
        csi = csi(1, :, :);
        csi = squeeze(csi);

        sanitized_csi = spotfi_algorithm_1(csi, sub_freq_delta);
        smoothed_sanitized_csi = smooth_csi(sanitized_csi);
        [aoa_packet_data{i}, tof_packet_data{i}] = aoa_tof_music(smoothed_sanitized_csi, antenna_distance, frequency, sub_freq_delta, data_name);
        disp(i);
    end
    disp('music over');
    l = 0;
    for packet_index = 1:num_packets
        tof_matrix = tof_packet_data{packet_index};
        aoa_matrix = aoa_packet_data{packet_index};
        % AoA Loop
        for j = 1:size(aoa_matrix, 1)
            l = l + 1;
            full_measurement_matrix(l,1) = aoa_matrix(j, 1);
            full_measurement_matrix(l,2) = tof_matrix(j, 1);
        end
    end
    disp('full over');
    % tmp = sort(full_measurement_matrix(:,1));
    % scatter(1:size(tmp,1),tmp);
    aoa_max = max(abs(full_measurement_matrix(:, 1)));
    tof_max = max(abs(full_measurement_matrix(:, 2)));
    full_measurement_matrix(:, 1) = full_measurement_matrix(:, 1) / aoa_max;
    full_measurement_matrix(:, 2) = full_measurement_matrix(:, 2) / tof_max;
    write_to_file(full_measurement_matrix,aoa_max,tof_max)
    scatter(full_measurement_matrix(:,1),full_measurement_matrix(:,2))
    [cluster_indices,clusters] = aoa_tof_cluster(full_measurement_matrix);
    data_cluster = clusters_find(clusters);
    pair_of_aoa_tof = full_measurement_matrix;
    disp('cluster');
    
    fprintf('likelihood\n');
    weight_num_cluster_points = 0.0001 * 10^-3;
    weight_aoa_variance = -0.7498 * 10^-3;
    weight_tof_variance = 0.0441 * 10^-3;
    weight_tof_mean = -0.0474 * 10^-3;
    constant_offset = -1;

    likelihood = zeros(length(clusters), 1);
    cluster_aoa = zeros(length(clusters), 1);
    max_likelihood_index = -1;
    top_likelihood_indices = [-1; -1; -1; -1; -1;];
    for ii = 1:length(clusters)
        % Ignore clusters of size 1
        if size(clusters{ii}, 1) == 0
            continue
        end
        % Initialize variables
        num_cluster_points = size(clusters{ii}, 1);
        aoa_mean = 0;
        tof_mean = 0;
        aoa_variance = 0;
        tof_variance = 0;
        % Compute Means
        for jj = 1:num_cluster_points
            aoa_mean = aoa_mean + clusters{ii}(jj, 1);
            tof_mean = tof_mean + clusters{ii}(jj, 2);
        end
        aoa_mean = aoa_mean / num_cluster_points;
        tof_mean = tof_mean / num_cluster_points;
        % Compute Variances
        for jj = 1:num_cluster_points
            aoa_variance = aoa_variance + (clusters{ii}(jj, 1) - aoa_mean)^2;
            tof_variance = tof_variance + (clusters{ii}(jj, 2) - tof_mean)^2;
        end
        aoa_variance = aoa_variance / (num_cluster_points - 1);
        tof_variance = tof_variance / (num_cluster_points - 1);
        % Compute Likelihood

        exp_body = weight_num_cluster_points * num_cluster_points ...
                + weight_aoa_variance * aoa_variance ...
                + weight_tof_variance * tof_variance ...
                + weight_tof_mean * tof_mean ...
                + constant_offset;
        likelihood(ii, 1) = exp_body;%exp(exp_body);
        % Compute Cluster Average AoA
        for jj = 1:size(clusters{ii}, 1)
            cluster_aoa(ii, 1) = cluster_aoa(ii, 1) + aoa_max * clusters{ii}(jj, 1);
        end
        cluster_aoa(ii, 1) = cluster_aoa(ii, 1) / size(clusters{ii}, 1);
        % Check for maximum likelihood
        if max_likelihood_index == -1 ...
                || likelihood(ii, 1) > likelihood(max_likelihood_index, 1)
            max_likelihood_index = ii;
        end
        % Record the top maximum likelihoods
        for jj = 1:size(top_likelihood_indices, 1)
            % Replace empty slot
            if top_likelihood_indices(jj, 1) == -1
                top_likelihood_indices(jj, 1) = ii;
                break;
            % Add somewhere in the list
            elseif likelihood(ii, 1) > likelihood(top_likelihood_indices(jj, 1), 1)
                % Shift indices down
                for kk = size(top_likelihood_indices, 1):-1:(jj + 1)
                    top_likelihood_indices(kk, 1) = top_likelihood_indices(kk - 1, 1);
                end
                top_likelihood_indices(jj, 1) = ii;
                break;
            % Add an extra item to the list because the likelihoods are all equal...
            elseif likelihood(ii, 1) == likelihood(top_likelihood_indices(jj, 1), 1) ...
                    && jj == size(top_likelihood_indices, 1)
                top_likelihood_indices(jj + 1, 1) = ii;
                break;
            end
        end
    end
    % Select AoA
    fprintf('select AoA\n');
    max_likelihood_average_aoa = cluster_aoa(max_likelihood_index, 1);
    % Profit
    temp = find(top_likelihood_indices~=-1);
    top_likelihood_indices = top_likelihood_indices(temp);
    output_top_aoas = cluster_aoa(top_likelihood_indices);
end