function start_spotfi(csi_filepath)
    if nargin < 1
        csi_filepath = 'data/2m-30.dat';
    end
    antenna_distance = 0.06;
    counts_likelihood = 5;
    counts_packets = 1;%¿ªÊ¼ÐòºÅ
    frequency = 5.8250e+09;
    sub_freq_delta = 6.6667e+05;
    [test_aoa_packet_0,test_aoa_packet_1,test_aoa_packet_2] = get_aoa_tof_pair_test(csi_filepath, counts_packets, antenna_distance, frequency, sub_freq_delta);
    [test_full_aoa_packet_0,test_full_aoa_packet_1,test_full_aoa_packet_2] = get_full_measurement_matrix_test(test_aoa_packet_0,test_aoa_packet_1,test_aoa_packet_2)
    [~,test_clusters_0] = get_clusters([test_full_aoa_packet_0.theta,test_full_aoa_packet_0.tau]);
    [~,test_clusters_1] = get_clusters([test_full_aoa_packet_1.theta,test_full_aoa_packet_1.tau]);
    draw(test_clusters_0,1);
    draw(test_clusters_1,2);
    result_0 = get_likelihood_matrix(test_clusters_0,test_full_aoa_packet_0.aoa_max,test_full_aoa_packet_0.tof_max,counts_likelihood)
    result_1 = get_likelihood_matrix(test_clusters_1,test_full_aoa_packet_1.aoa_max,test_full_aoa_packet_1.tof_max,counts_likelihood)
end
