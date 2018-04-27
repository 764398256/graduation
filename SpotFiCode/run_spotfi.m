%Write by Joey
%aoa_packet_data:ÿ�����ݰ���aoa������ÿ�����ݰ���musicƵ�׵õ��Ĳ�����Ӧ��aoa
%tof_packet_data:ÿ�����ݰ���tof������ÿ�����ݰ���musicƵ�׵õ��Ĳ�����Ӧ��tof
%output_top_aoaos:ǰ5�����п�����ֱ��·����AOA
function [aoa_packet_data,tof_packet_data,output_top_aoas] = run_spotfi(filepath)
    antenna_distance = 0.06; %天线间距
    frequency = 5.825 * 10^9; %发射天线载波频率
    sub_freq_delta = (20 * 10^6) /30; %？？？

    csi_trace = readfile(filepath); %数据读取
    num_packets = floor(length(csi_trace)/1); %向下取整
    sampled_csi_trace = csi_sampling(csi_trace, num_packets, 1, length(csi_trace));%抽样，实际上和csi_trace长度一样
    [aoa_packet_data,tof_packet_data,output_top_aoas] = spotfi(sampled_csi_trace, frequency, sub_freq_delta, antenna_distance);
end
