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
        csi = csi(1, :, :);
        csi = squeeze(csi);
        csi_data(i,1:30) = csi(1,:);
        csi_data(i,31:60) = csi(2,:);
        csi_data(i,61:90) = csi(3,:);
    end
end