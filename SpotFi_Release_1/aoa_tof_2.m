function result = aoa_tof_2(Pmusic,theta,tau)
tof_flag = 1;
tof_pair_flag = 1;
result.theta = 0;
result.tau = 0
for i=1:size(Pmusic,2)
    [~,aoa_index] = findpeaks(Pmusic(:, i));
    for j=1:size(aoa_index)
        result(tof_pair_flag).theta = theta(aoa_index(j));
        result(tof_pair_flag).tau = tau(tof_flag);
        tof_pair_flag = tof_pair_flag + 1;
    end
    tof_flag = tof_flag + 1;
    % disp(aoa_index);
end
end
