%   ->
%  功能：开发脚本
%  参数表：无
%  输出：无
%  简介：尝试文件读取
%
function list_all_figure
    files = dir(fullfile('data'));
    for i = 1:length(files)
        if size(strfind(files(i).name,'.dat'),1) > 0
            filepath = strcat('data/',files(i).name);
            [~,~,out] = get_aoa_and_real_angle(filepath);
            fprintf("\n%s:",filepath);
            disp(out);
        end
    end
end
