function csi_data = read_csi(filepath)
    if nargin < 1
        filepath = 'data/90.dat';
    end
    csi_trace = readfile(filepath);
    num_trace = 100;%size(csi_trace,1);
    csi_data = zeros(num_trace,90);
    for i=1:num_trace
        csi_entry = csi_trace{i};
        csi = get_scaled_csi(csi_entry);
        plot(db(abs(squeeze(csi(1,:,:)).')));
        legend('RX Antenna A', 'RX Antenna B', 'RX Antenna C', 'Location', 'SouthEast' );
        xlabel('Subcarrier index');
        ylabel('SNR [dB]');
        % hold on;
        t = db(get_eff_SNRs(csi), 'pow');
        % csi = csi(1, :, :);
        % csi = squeeze(csi);
        % csi_data(i,1:30) = csi(1,:);
        % csi_data(i,31:60) = csi(2,:);
        % csi_data(i,61:90) = csi(3,:);
    end
    % 
    
    
    phase = unwrap(angle(csi_data), pi, 2);
    Y = zeros(90,1);
    Z = zeros(90,1);
    for i=1:90
        Y(i) = mean(abs(csi_data(:,i)));
        Z(i) = mean(phase(:,i));
    end
    % plot(1:90,Y);
    % plot(1:90,Z);
    plot(1:90,Y.*exp(1i*Z));
end