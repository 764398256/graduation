%   ->
%  功能：在计算likelihood前对数据做些小小的处理，以下代码完全可以归入likelihood文件中
%  参数表：clusters -> 上文得出的聚类,aoa_max -> 归一化的分母,tof_max -> 归一化的分母
%  输出：clusters_struct -> 结构体数组
%  简介：开发用
%
function clusters_struct = cluster_weight(clusters,aoa_max,tof_max)
    parfor (i=1:size(clusters,1),4)
       tmp = clusters{i,1}.*[aoa_max,tof_max];
       clusters_struct(i).cluster = tmp;
       clusters_struct(i).point_num = size(tmp,1);

       % clusters_struct(i).aoa_var = round(var(tmp(:,1)));
       % clusters_struct(i).tof_var = round(var(tmp(:,2)) * 1e19);
       % clusters_struct(i).tof_mean = round(mean(tmp(:,2)) * 1e10);
       % clusters_struct(i).aoa_mean = round(mean(tmp(:,1)));

       clusters_struct(i).aoa_var = var(tmp(:,1));
       clusters_struct(i).tof_var = var(tmp(:,2));
       clusters_struct(i).tof_mean = mean(tmp(:,2));
       clusters_struct(i).aoa_mean = mean(tmp(:,1));
    end
end
