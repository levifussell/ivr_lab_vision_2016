function [data_bins] = create_cv_train_test_data(data_m, num_classes, num_bins)

    data_bins = {};

    for c=1:num_bins
        data_bins{c} = [];
    end
        
    
    for i=1:num_classes
    
        class_data = data_m(find(data_m(:, size(data_m, 2)) == i), :); 

        % shuffle the matrix
        rand_v = rand(size(class_data, 1), 1);
        [r_sort, r_idx] = sort(rand_v);
        class_data_shuffled = class_data(r_idx, :);

        indx_rate = size(class_data_shuffled, 1) ./ num_bins;
        
        for c=1:num_bins
            c_min = 1 + floor((c - 1) * indx_rate);
            c_max = ceil(c * indx_rate);
            class_train = class_data_shuffled(c_min:c_max, :);
            s_data_test = size(data_bins{c}, 1);
            s_data_train = size(data_bins{c}, 1);
            data_bins{c}((s_data_train + 1):(s_data_train + size(class_train, 1)), :) = class_train;
        end
        
    end

end

