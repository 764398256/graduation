function data = clusters_find(clusters)
    data = [];
    row = 0;
    for i = 1:size(clusters,1)
        tmp = clusters{i,1};
        for j = 1:size(tmp,1)
            row = row + 1;
            data(row,1) = tmp(j,1);
            data(row,2) = tmp(j,2);
        end
    end
    scatter(data(:,1),data(:,2),'K')
end