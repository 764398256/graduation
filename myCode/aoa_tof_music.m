function [estimated_aoas, estimated_tofs] = aoa_tof_music(x, antenna_distance, frequency, sub_freq_delta, snr, data_name)
    if nargin == 4
        data_name = '-';
    end
    
    signal_N = 1;
    array_N = 3;
    carrier_N = 30;
    ratio = 0.5;
    R = x * x';
    [V,D]=eig(R);
    [D,I]=sort(diag(D));
    v = V(:,I(1:array_N - signal_N));
    eigenvectors = [awgn(v,snr(1));awgn(v,snr(1));awgn(v,snr(1))];

    theta = -180:1:180;
    tau = 0:(1.0e-9):(100e-9);

    Pmusic = music_spectrum(theta,tau,frequency, sub_freq_delta, antenna_distance,eigenvectors);

    % tof => x
    tof_pair_flag = 1;
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

    % aoa => x
%     aoa_pair_flag = 1;
%     for i=1:size(Pmusic,1)
%         [~,tof_index] = findpeaks(Pmusic(i,:));
%         if isempty(tof_index)
%             continue;
%         end
%         for j=1:size(tof_index)
%             [~,aoa_index] = findpeaks(Pmusic(:, tof_index(j)));
%             if isempty(aoa_index)
%                 continue;
%             end
%             for k=1:size(aoa_index)
%                 aoa_pair(aoa_pair_flag).theta = theta(aoa_index(k));
%                 aoa_pair(aoa_pair_flag).tau = tau(tof_index(j));
%                 aoa_pair_flag = aoa_pair_flag + 1;
%             end
%             
%         end
% 
%         % disp(aoa_index);
%     end

    % combain
%     estimated_aoas = [aoa_pair(:).theta,tof_pair(:).theta]';
%     estimated_tofs = [aoa_pair(:).tau,tof_pair(:).tau]';
     estimated_aoas = [tof_pair(:).theta]';
     estimated_tofs = [tof_pair(:).tau]';
end

function Pmusic = music_spectrum(theta,tau,frequency, sub_freq_delta, antenna_distance,eigenvectors)
    Pmusic = zeros(length(theta), length(tau));
    % Angle of Arrival Loop (AoA)
    for ii = 1:length(theta)
        % Time of Flight Loop (ToF)
        for jj = 1:length(tau)
            steering_vector = compute_steering_vector(theta(ii), tau(jj), ...
                    frequency, sub_freq_delta, antenna_distance);
            PP = steering_vector' * (eigenvectors * eigenvectors') * steering_vector;
            Pmusic(ii, jj) = abs(1 /  PP);
        end
    end

    % ToF loop
    for jj = 1:size(Pmusic, 2)
        % AoA loop
        for ii = 1:size(Pmusic, 1)
            Pmusic(ii, jj) = 10 * log10(Pmusic(ii, jj));% / max(Pmusic(:, jj)));
            Pmusic(ii, jj) = abs(Pmusic(ii, jj));
        end
    end
end

function steering_vector = compute_steering_vector(theta, tau, freq, sub_freq_delta, ant_dist)
    steering_vector = zeros(30, 1);
    k = 1;
    base_element = 1;
    for ii = 1:3
        for jj = 1:30
            steering_vector(k, 1) = base_element * omega_tof_phase(tau, sub_freq_delta)^(jj - 1);
            k = k + 1;
        end
        base_element = base_element * phi_aoa_phase(theta, freq, ant_dist);
    end
end

function time_phase = omega_tof_phase(tau, sub_freq_delta)
    time_phase = exp(-1i * 2 * pi * sub_freq_delta * tau);
end

function angle_phase = phi_aoa_phase(theta, frequency, d)
    c = 3.0 * 10^8;
    theta = theta / 180 * pi;
    angle_phase = exp(-1i * 2 * pi * d * sin(theta) * (frequency / c));
end

