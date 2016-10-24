
data_x = randn(5, 1);
data_y = randn(5, 1);
data = [data_x, data_y];

figure(1)
scatter(data(:, 1), data(:, 2))

itterationCount = 0;

for i=1:1000

    % for j=1:size(data, 2)
    %     data_v = data(:, j);
    % repeat_matrix = [1:(size(data, 1) * size(data, 2)); transpose(size(data, 1) * ones(size(data, 1) * size(data, 2)))];
    repeated_data = repmat(data, [1, 1, size(data, 1)]);

    % repeated_data = reshape(transpose(repelems(data_v, repeat_matrix)), size(data_v, 1), size(data_v, 1));

    duplicate_val_data = zeros(size(repeated_data));
    for i=1:size(data, 1)
        duplicate_val_data(:, :, i) = repmat(data(i, :), size(data, 1), 1);
    end

    h = 10;
    diff_abs = reshape(abs(duplicate_val_data - repeated_data) / h, size(repeated_data, 1) .* size(repeated_data, 3), size(repeated_data, 2));
    diff_matrix = gauss_deriv(diff_abs);

    mean_shift_vector_d = ...
        transpose(sum(diff_matrix .* repmat(data, size(data, 1), 1), 1) ... 
        ./ sum(diff_matrix, 1)) - data;
    % end

    prev_data = data;
    data = data + mean_shift_vector_d;
    data = sort(data, 1);

    % detect if the clusters have reached equilibrium
    threshold_error = 0.00001;
    is_equilibrium = (data - prev_data) < 0.001;

    if sum(sum(is_equilibrium, 1), 1) == size(data_v, 1) * size(data_v, 2)
        itterationCount
        break;
    end

    itterationCount++;
end

hold on
scatter(data(:, 1), data(:, 2), 10, 'red')