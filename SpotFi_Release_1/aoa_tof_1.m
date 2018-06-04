function result = aoa_tof_1(Pmusic,theta,tau)
tof_flag = 1;
tof_pair_flag = 1;
result.theta = 0;
result.tau = 0
for i=1:size(Pmusic,2)
    [~,aoa_index] = findpeaks(Pmusic(:, i));
    for j=1:size(aoa_index)
        tof_pair(tof_pair_flag).theta = theta(aoa_index(j));
        tof_pair(tof_pair_flag).tau = tau(tof_flag);
        tof_pair_flag = tof_pair_flag + 1;
    end
    tof_flag = tof_flag + 1;
    % disp(aoa_index);
end

% aoa => x
aoa_flag = 0;
aoa_pair_flag = 1;
aoa_isempty = 1;
for i=1:size(Pmusic,1)
    [~,tof_index] = findpeaks(Pmusic(i,:));
    aoa_flag = aoa_flag + 1;
    if isempty(tof_index)
        continue;
    end
    aoa_isempty = 0;
    for j=1:size(tof_index)
        aoa_pair(aoa_pair_flag).theta = theta(aoa_flag);
        aoa_pair(aoa_pair_flag).tau = tau(tof_index(j));
        aoa_pair_flag = aoa_pair_flag + 1;
    end

    % disp(aoa_index);
end

res_index = 1;
  if aoa_pair_flag > 1
      for i=1:size(aoa_pair,2)
        result(res_index).theta = aoa_pair(i).theta;
        result(res_index).tau = aoa_pair(i).tau;
        res_index = res_index + 1;
      end
  end
  if tof_pair_flag > 1
      for i=1:size(tof_pair,2)
        result(res_index).theta = tof_pair(i).theta;
        result(res_index).tau = tof_pair(i).tau;
        res_index = res_index + 1;
      end
  end
end
