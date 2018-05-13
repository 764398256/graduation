function [antenna_distance, frequency, sub_freq_delta, counts_packets, counts_likelihood] = get_parameter(conf_filepath)
    fprintf('Phase 1: Get Parameter\nStart:\n');
    pause(3);
    conf = xmlread(conf_filepath);
    
    antenna_distance_str = conf.getElementsByTagName('antenna_distance').item(0).getTextContent();
    frequency_str = conf.getElementsByTagName('frequency').item(0).getTextContent();
    sub_freq_delta_str = conf.getElementsByTagName('sub_freq_delta').item(0).getTextContent();
    counts_packets_str = conf.getElementsByTagName('counts_packets').item(0).getTextContent();
    counts_likelihood_str = conf.getElementsByTagName('counts_likelihood').item(0).getTextContent();
    
    antenna_distance = str2double(antenna_distance_str);
    split_e = split(frequency_str,'e');
    frequency = str2double(split_e(1,1)) * 10 ^ str2num(split_e(2,1));
    split_e = split(sub_freq_delta_str,'e');
    split_d = split(split_e(1,1),'/');
    sub_freq_delta  = str2num(split_d(1,1)) / str2num(split_d(2,1)) * 10 ^ str2num(split_e(2,1));
    counts_packets = str2num(counts_packets_str);
    counts_likelihood = str2num(counts_likelihood_str);
    fprintf('Phase 1 Finished.\n');
    pause(1);
end
