function clusters = clusters_gmm(full_measurement_matrix)
    model=gmmEM(full_measurement_matrix,5);
    data = model.Yz;
    clusters = cell(size(data,2),1);
    clusters_index = ones(size(data,2),1);
    for i=1:size(data,1)
        [~,index] = max(data(i,:));
        clusters{index}(clusters_index(index),1) = full_measurement_matrix(i,1);
        clusters{index}(clusters_index(index),2) = full_measurement_matrix(i,2);
        clusters_index(index) = clusters_index(index) + 1;
    end
end