function [test_aoa_0,test_aoa_1,test_aoa_2] = music_aoa_test(x, antenna_distance, frequency, sub_freq_delta, data_name)
    if nargin == 4
        data_name = '-';
    end

    signal_N = 1;
    array_N = 3;
    R = x * x';
    [V,D]=eig(R);
    [D,I]=sort(diag(D));
    eigenvectors = V(:,I(1:array_N - signal_N));

    theta = -180:1:180;
    tau = 0:(1.0e-9):(100e-9);

    Pmusic = music_spectrum(theta,tau,frequency, sub_freq_delta, antenna_distance,eigenvectors);
    test_aoa_0 = aoa_tof_0(Pmusic,theta,tau);
    test_aoa_1 = aoa_tof_1(Pmusic,theta,tau);
    test_aoa_2 = aoa_tof_2(Pmusic,theta,tau);
end
