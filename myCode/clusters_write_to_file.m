%   ->
%  功能：开发脚本
%  参数表：clusters_struct -> 处理后的clusters
%  输出：无
%  简介：提取数据存入外部
%
function clusters_write_to_file(clusters_struct)
    if nargin < 2
        name = 'clusters_1_10000.txt'
    end
    % disp(matrix);
    fid = fopen(name,'w');
    fprintf(fid,'point_numbers,aoa_var,tof_var,tof_mean,aoa_mean\n\n');
    for i = 1:size(clusters_struct,2)
        fprintf(fid,'%d,%d,%d,%d,%d\n',clusters_struct(i).point_num,clusters_struct(i).aoa_var,clusters_struct(i).tof_var,clusters_struct(i).tof_mean,clusters_struct(i).aoa_mean);
    end
    fclose(fid);
end
