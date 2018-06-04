function result = aoa_tof_0(Pmusic,theta,tau)
  tof_pair_flag = 1;
  result.theta = 0;
  result.tau = 0;
  for i=1:size(Pmusic,2)
    [~,aoa_index] = findpeaks(Pmusic(:, i));
    if isempty(aoa_index)
      continue;
    end
    for j=1:size(aoa_index)
      [~,tof_index] = findpeaks(Pmusic(aoa_index(j),:));
      if isempty(tof_index)
        continue;
      end

      for k=1:size(tof_index)
      tof_pair(tof_pair_flag).theta = theta(aoa_index(j));
      tof_pair(tof_pair_flag).tau = tau(tof_index(k));
      tof_pair_flag = tof_pair_flag + 1;
      end
    end
  end

  aoa_pair_flag = 1;
  for i=1:size(Pmusic,1)
    [~,tof_index] = findpeaks(Pmusic(i,:));
    if isempty(tof_index)
      continue;
    end
    for j=1:size(tof_index)
      [~,aoa_index] = findpeaks(Pmusic(:, tof_index(j)));
      if isempty(aoa_index)
        continue;
      end
      for k=1:size(aoa_index)
        aoa_pair(aoa_pair_flag).theta = theta(aoa_index(k));
        aoa_pair(aoa_pair_flag).tau = tau(tof_index(j));
        aoa_pair_flag = aoa_pair_flag + 1;
      end
    end
    disp(aoa_index);
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
