function p=get_pic_doa(url,fig) %函数声明
path(path,'../'); %返回父目录
csi_trace = read_bf_file(url); %读取url代表的csi数据
[csi_size,tmp]=size(csi_trace); %tmp无用，获取数据长度
set(figure(fig),'WindowStyle','docked'); %set(gca,,,)函数的作用是在做的图上插入坐标轴的坐标标注

theta = -90:1:90; %角度，从-90增到90，步长为1，结果是个矩阵
Pmusic_total = zeros(length(theta),1); % 0矩阵，大小和上面一样

for ii=1:length(csi_trace) %遍历csi数据

    csi_entry = csi_trace{ii};
    csi_s=size(csi_entry);
    if(csi_s(1)==0)
        csi_size=ii;
        break;
    end
    csi = csi_entry.csi;
    if csi==0
        break;
    end

    csi = squeeze(csi); %去掉size为1的纬度，例：4x1x3=>4x3
    cir = cir_via_ifft(csi); %对csi矩阵进行逆傅立叶变换

    M=3;
    fc = 2.422*10^9; %载波频率
    ant_dist = 0.06; %天线间距

    R = csi*csi';
    [eigenvectors, eigenvalue_matrix] = eig(R); %特征向量
    I = eye(M); %单位矩阵


    Pmusic = zeros(length(theta),1);
    for ii = 1:length(theta)
        steering_vector = comput_steering_vector(theta(ii), fc, ant_dist);
        PP = steering_vector'*(I-eigenvectors*eigenvectors')*steering_vector;
        Pmusic(ii) =abs(1/PP);
    end
    Pmusic = 10*log10(Pmusic);
    Pmusic_total = Pmusic_total+Pmusic;

%     clf;
%     plot(theta, Pmusic');
    % A=cir*cir';%3*3
    %
    % [U,S,V]=svd(A);
    % v=V;
    % igenval=sqrt(diag(S));
    %
    % Vn=noise_sub_sp(v,igenval);          %find the noise subspace
    %
    % VnVnH=Vn*Vn';
    %
    % q=1;
    % theta(q)=1;
    % while (q <= 180)
    % 	if (q~=1)
    % 		theta(q)=theta(q-1)+1;
    % 	end
    % 	thetainrad = pi*theta(q)/180;
    % 	for p=1:M
    % 		sigvect(p)=exp(-j*pi*cos(thetainrad)*(p-1));
    % 	end
    % 	sigvec=sigvect.';
    % 	denom=sigvec'*VnVnH*sigvec;
    % 	Spectrum(q)=1/denom;
    % 	q=q+1;
    % end
    % spectrum=abs(Spectrum);
    % big=max(spectrum);
    % spectrum=spectrum./big;
    % normspec=10*log10(spectrum);
    % clf;
    % plot(theta,10*log10(spectrum));
end
plot(theta, (10*log10(Pmusic_total))');
end

function steering_vector = comput_steering_vector(theta, freq, ant_dist)
    steering_vector = zeros(3,1);
    for ii = 1:3
        steering_vector(ii) = phi_aoa_phase(theta, freq, (ii-1)*ant_dist);
    end
end

function angle_phase = phi_aoa_phase(theta, frequency, d)
    % Speed of light (in m/s)
    c = 3.0 * 10^8;
    % Convert to radians
    theta = theta / 180 * pi;
    angle_phase = exp(-1i * 2 * pi * d * sin(theta) * (frequency / c));
end
