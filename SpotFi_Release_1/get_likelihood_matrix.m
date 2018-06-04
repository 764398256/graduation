function result = get_likelihood_matrix(clusters,aoa_max,tof_max,counts_likelihood)
    fprintf('Phase 5: Get Likelihood Matrix\nStart:\n');
    clusters_struct = cluster_weight(clusters,aoa_max,tof_max);
    length = size(clusters_struct,2);
    tmp = zeros(length,2);
    likehood_index = ones(1,counts_likelihood);
    result = zeros(counts_likelihood,2);
    for i=1:length
        tmp(i,2) = clusters_struct(i).aoa_mean;
        weight_num_cluster_points = 1e-2;
        weight_aoa_variance = -8e-2;
        weight_tof_variance = -1e17;
        weight_tof_mean = -1e8;
        tmp(i,1) = ...
            weight_num_cluster_points * clusters_struct(i).point_num ...
            + weight_aoa_variance * clusters_struct(i).aoa_var ...
            + weight_tof_variance * clusters_struct(i).tof_var ...
            + weight_tof_mean * clusters_struct(i).tof_mean;
    end
    for i = 1:size(tmp)
        flag = tmp(i,1);
        for j = 1:counts_likelihood
            if flag > tmp(likehood_index(j))
                for k = counts_likelihood:-1:j+1
                    likehood_index(k) = likehood_index(k-1)
                end
                likehood_index(j) = i;
                break;
            end
        end
    end
    for i=1:counts_likelihood
        result(i,1) = clusters_struct(likehood_index(i)).aoa_mean;
        result(i,2) = clusters_struct(likehood_index(i)).tof_mean;
    end
    fprintf('Phase 5 Finished.\n');
end

function clusters_struct = cluster_weight(clusters,aoa_max,tof_max)
    for i=1:size(clusters,1)
       tmp = clusters{i,1}.*[aoa_max,tof_max];
       clusters_struct(i).cluster = tmp;
       clusters_struct(i).point_num = size(tmp,1);

       clusters_struct(i).aoa_var = var(tmp(:,1));
       clusters_struct(i).tof_var = var(tmp(:,2));
       clusters_struct(i).tof_mean = mean(tmp(:,2));
       clusters_struct(i).aoa_mean = mean(tmp(:,1));
    end
end
