function scatter_test_points(test_full_packet,num)
    aoa = [test_full_packet.theta];
    tof = [test_full_packet.tau];
    figure(num);
    scatter(aoa,tof);
    xlabel('aoa');
    ylabel('tof');
end