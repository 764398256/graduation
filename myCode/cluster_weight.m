function clusters_struct = cluster_weight(clusters,aoa_max,tof_max)
    for i=1:size(clusters,1)
       tmp = clusters(i,1)*[aoa_max,0;0,tof_max];
       clusters_struct(i).cluster = tmp;
       clusters_struct(i).point_num = size(tmp);
       clusters_struct(i).aoa_var = var(tmp(:,1));
       clusters_struct(i).tof_var = var(tmp(:,2));
       clusters_struct(i).tof_mean = mean(tmp(:,2));
       clusters_struct(i).aoa_mean = mean(tmp(:,1));
    end
end