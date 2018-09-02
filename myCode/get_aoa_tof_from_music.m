function [estimated_aoas, estimated_tofs] = get_aoa_tof_from_music(Pmusic,theta,tau)
    % tof => x
    tof_flag = 1;
    tof_pair_flag = 1;
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
    
    % combain
    if aoa_isempty == 0
        estimated_aoas = [aoa_pair(:).theta,tof_pair(:).theta]';
        estimated_tofs = [aoa_pair(:).tau,tof_pair(:).tau]';
    else
        estimated_aoas = [tof_pair(:).theta]';
        estimated_tofs = [tof_pair(:).tau]';
    end
end
