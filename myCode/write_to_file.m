function write_to_file(matrix,aoa_max,tof_max,name)
    if nargin < 4
        name = 'aoa_tof_40001_50000.txt'
    end
    % disp(matrix);
    fid = fopen(name,'w');
    fprintf(fid,'%.20f,%.20f\n\n',aoa_max,tof_max);
    for i = 1:size(matrix,1)
        disp(matrix(i,:));
        fprintf(fid,'%.20f,%.20f\n',matrix(i,1),matrix(i,2));
    end
    fclose(fid);
end