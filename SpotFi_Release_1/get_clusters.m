function [cluster_indices,clusters] = get_clusters(full_measurement_matrix)
    fprintf('Phase 4: Get Clusters\nStart:\n');
    pause(3);
    X = pdist(full_measurement_matrix,'euclidean');
    linkage_tree = linkage(X, 'ward');
    cluster_indices_vector = cluster(linkage_tree, 'CutOff', 1.0, 'criterion', 'distance');
    cluster_count_vector = zeros(0, 1);
    num_clusters = 0;
    for ii = 1:size(cluster_indices_vector, 1)
        if ~ismember(cluster_indices_vector(ii), cluster_count_vector)
            cluster_count_vector(size(cluster_count_vector, 1) + 1, 1) = cluster_indices_vector(ii);
            num_clusters = num_clusters + 1;
        end
    end

    clusters = cell(num_clusters, 1);
    cluster_indices = cell(num_clusters, 1);
    for ii = 1:size(cluster_indices_vector, 1)
        tail_index = size(clusters{cluster_indices_vector(ii, 1)}, 1) + 1;
        clusters{cluster_indices_vector(ii, 1)}(tail_index, :) = full_measurement_matrix(ii, :);
        cluster_index_tail_index = size(cluster_indices{cluster_indices_vector(ii, 1)}, 1) + 1;
        cluster_indices{cluster_indices_vector(ii, 1)}(cluster_index_tail_index, 1) = ii;
    end
    fprintf('Phase 4 Finished.\n');
    pause(1);
end
