function [full_measurement_matrix,aoa_max,tof_max] = get_full_measurement_matrix(aoa_packet_data, tof_packet_data)
    fprintf('Phase 3: Get Full Matrix\nStart:\n');
    l = 0;
    for packet_index = 1:size(aoa_packet_data,1)
        tof_matrix = [tof_packet_data{packet_index}]';
        aoa_matrix = [aoa_packet_data{packet_index}]';
        for j = 1:size(aoa_matrix, 1)
            if tof_matrix(j, 1) <= 0
                continue;
            end
            l = l + 1;
            full_measurement_matrix(l,1) = aoa_matrix(j, 1);
            full_measurement_matrix(l,2) = tof_matrix(j, 1);
        end
    end
    aoa_max = max(abs(full_measurement_matrix(:, 1)));
    tof_max = max(abs(full_measurement_matrix(:, 2)));
    full_measurement_matrix(:, 1) = full_measurement_matrix(:, 1) / aoa_max;
    full_measurement_matrix(:, 2) = full_measurement_matrix(:, 2) / tof_max;
    fprintf('Phase 3 Finished.\n');
end
