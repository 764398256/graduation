function [cluster_indices,clusters] = aoa_tof_cluster(full_measurement_matrix)
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

    % Collect data and indices into cluster-specific cell arrays
    clusters = cell(num_clusters, 1);
    cluster_indices = cell(num_clusters, 1);
    for ii = 1:size(cluster_indices_vector, 1)
        % Save off the data
        tail_index = size(clusters{cluster_indices_vector(ii, 1)}, 1) + 1;
        clusters{cluster_indices_vector(ii, 1)}(tail_index, :) = full_measurement_matrix(ii, :);
        % Save off the indexes for the data
        cluster_index_tail_index = size(cluster_indices{cluster_indices_vector(ii, 1)}, 1) + 1;
        cluster_indices{cluster_indices_vector(ii, 1)}(cluster_index_tail_index, 1) = ii;
    end
    
    for ii = 1:size(clusters, 1)
        % Delete clusters that are < 5% of the size of the number of packets
        if size(clusters{ii}, 1) < (0.05 * num_packets)
            clusters{ii} = [];
            cluster_indices{ii} = [];
            continue;
        end
        alpha = 0.05;
        [~, outlier_indices, ~] = deleteoutliers(clusters{ii}(:, 1), alpha);
        cluster_indices{ii}(outlier_indices(:), :) = [];
        clusters{ii}(outlier_indices(:), :) = [];

        alpha = 0.05;
        [~, outlier_indices, ~] = deleteoutliers(clusters{ii}(:, 2), alpha);
        cluster_indices{ii}(outlier_indices(:), :) = [];
        clusters{ii}(outlier_indices(:), :) = [];
    end
end
