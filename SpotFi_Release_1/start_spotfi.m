function result = start_spotfi(csi_filepath,counts_packets)
    if nargin < 1
        csi_filepath = 'data/2m-30.dat';
    end
    antenna_distance = 0.06;
    counts_likelihood = 5;
    frequency = 5.8250e+09;
    sub_freq_delta = 6.6667e+05;
    [aoa_packet_data, tof_packet_data] = get_aoa_tof_pair(csi_filepath, counts_packets, antenna_distance, frequency, sub_freq_delta);
    [full_measurement_matrix,aoa_max,tof_max] = get_full_measurement_matrix(aoa_packet_data, tof_packet_data);
    [~,clusters] = get_clusters(full_measurement_matrix);
    result = get_likelihood_matrix(clusters,aoa_max,tof_max,counts_likelihood)
end
