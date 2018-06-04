function [test_full_aoa_packet_0,test_full_aoa_packet_1,test_full_aoa_packet_2] = get_full_measurement_matrix_test(test_aoa_packet_0,test_aoa_packet_1,test_aoa_packet_2)
    fprintf('Phase 3: Get Full Matrix Test\nStart:\n');
    l = 0;
    for packet_index = 1:size(test_aoa_packet_0,1)
        if size(test_aoa_packet_0{packet_index,1},1) == 0
            continue;
        end
        tof_matrix = [test_aoa_packet_0{packet_index,1}.tau]';
        aoa_matrix = [test_aoa_packet_0{packet_index,1}.theta]';
        for j = 1:size(aoa_matrix, 1)
            if tof_matrix(j, 1) <= 0
                continue;
            end
            l = l + 1;
            test_full_aoa_packet_0.theta(l,1) = aoa_matrix(j, 1);
            test_full_aoa_packet_0.tau(l,1) = tof_matrix(j, 1);
        end
    end
    test_full_aoa_packet_0.aoa_max = max(abs(test_full_aoa_packet_0.theta(:)));
    test_full_aoa_packet_0.tof_max = max(abs(test_full_aoa_packet_0.tau(:)));
    test_full_aoa_packet_0.theta(:) = test_full_aoa_packet_0.theta(:) / test_full_aoa_packet_0.aoa_max;
    test_full_aoa_packet_0.tau(:) = test_full_aoa_packet_0.tau(:) / test_full_aoa_packet_0.tof_max;
    
    l = 0;
    for packet_index = 1:size(test_aoa_packet_1,1)
        if size(test_aoa_packet_1{packet_index,1},1) == 0
            continue;
        end
        tof_matrix = [test_aoa_packet_1{packet_index,1}.tau]';
        aoa_matrix = [test_aoa_packet_1{packet_index,1}.theta]';
        for j = 1:size(aoa_matrix, 1)
            if tof_matrix(j, 1) <= 0
                continue;
            end
            l = l + 1;
            test_full_aoa_packet_1.theta(l,1) = aoa_matrix(j, 1);
            test_full_aoa_packet_1.tau(l,1) = tof_matrix(j, 1);
        end
    end
    test_full_aoa_packet_1.aoa_max = max(abs(test_full_aoa_packet_1.theta(:)));
    test_full_aoa_packet_1.tof_max = max(abs(test_full_aoa_packet_1.tau(:)));
    test_full_aoa_packet_1.theta(:) = test_full_aoa_packet_1.theta(:) / test_full_aoa_packet_1.aoa_max;
    test_full_aoa_packet_1.tau(:) = test_full_aoa_packet_1.tau(:) / test_full_aoa_packet_1.tof_max;
    
    l = 0;
    for packet_index = 1:size(test_aoa_packet_2,1)
        
        if size(test_aoa_packet_2{packet_index,1},1) == 0
            continue;
        end
        tof_matrix = [test_aoa_packet_2{packet_index,1}.tau]';
        aoa_matrix = [test_aoa_packet_2{packet_index,1}.theta]';
        for j = 1:size(aoa_matrix, 1)
            if tof_matrix(j, 1) <= 0
                continue;
            end
            l = l + 1;
            test_full_aoa_packet_2.theta(l,1) = aoa_matrix(j, 1);
            test_full_aoa_packet_2.tau(l,1) = tof_matrix(j, 1);
        end
    end
    test_full_aoa_packet_2.aoa_max = max(abs(test_full_aoa_packet_2.theta(:)));
    test_full_aoa_packet_2.tof_max = max(abs(test_full_aoa_packet_2.tau(:)));
    test_full_aoa_packet_2.theta(:) = test_full_aoa_packet_2.theta(:) / test_full_aoa_packet_2.aoa_max;
    test_full_aoa_packet_2.tau(:) = test_full_aoa_packet_2.tau(:) / test_full_aoa_packet_2.tof_max;
    fprintf('Phase 3 Finished.\n');
end