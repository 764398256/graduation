function start_spotfi(conf_filepath,csi_filepath)
    if nargin < 1
        conf_filepath = 'conf/conf.xml';
        csi_filepath = 'data/45.dat';
    else
        if nargin < 2
            csi_filepath = 'data/45.dat';
        end    
    end
    
    [antenna_distance, frequency, sub_freq_delta, counts_packets, counts_likelihood] = get_parameter(conf_filepath);
    [aoa_packet_data, tof_packet_data] = get_aoa_tof_pair(csi_filepath, counts_packets, antenna_distance, frequency, sub_freq_delta);
    [full_measurement_matrix,aoa_max,tof_max] = get_full_measurement_matrix(aoa_packet_data, tof_packet_data);
    [~,clusters] = get_clusters(full_measurement_matrix);
    result = get_likelihood_matrix(clusters,aoa_max,tof_max,counts_likelihood)
end
