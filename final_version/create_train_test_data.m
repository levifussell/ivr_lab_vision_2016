function [data_train, data_test] = create_train_test_data(data_m, num_classes, percent_train)
% shuffles the data and sorts into training and testing data, also making
% sure to maintain the distribution of classes within each training and
% testing (because the classes are not all uniformly distributed)

    data_test = [];
    data_train = [];

    % itterate through each class to split into random train and test
    for i=1:num_classes
    
        % get data of a single class
        class_data = data_m(find(data_m(:, size(data_m, 2)) == i), :); 

        % shuffle the matrix
        rand_v = rand(size(class_data, 1), 1);
        [r_sort, r_idx] = sort(rand_v);
        class_data_shuffled = class_data(r_idx, :);

        % divide data into train/test
        class_data_idx = floor(size(class_data_shuffled, 1) * percent_train);
        class_train = class_data_shuffled(1:class_data_idx, :);
        class_test = class_data_shuffled((class_data_idx + 1):size(class_data_shuffled, 1), :);
        
        % push the train/test class data into the larger train/test sets
        s_data_test = size(data_test, 1);
        s_data_train = size(data_train, 1);
        data_train((s_data_train + 1):(s_data_train + size(class_train, 1)), :) = class_train;
        data_test((s_data_test + 1):(s_data_test + size(class_test, 1)), :) = class_test;

    end

end