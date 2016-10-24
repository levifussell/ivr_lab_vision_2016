
data_x = [randn(500, 1) + 1; randn(500, 1) - 2];
data_y = randn(10, 1);
data = [data_x, data_x];

figure(1)
scatter(data(:, 1), data(:, 2))

itterationCount = 0;

for i=1:10000

    repeat_matrix = [1:size(data_x, 1); transpose(size(data_x, 1) * ones(size(data_x)))];

    repeated_data = reshape(transpose(repelems(data_x, repeat_matrix)), size(data_x, 1), size(data_x, 1));

    h = 10;
    diff_matrix = gauss_deriv(abs(repmat(data_x, 1, size(data_x, 1)) - repeated_data) / h);

    mean_shift_vector = ...
        transpose(sum(diff_matrix .* repmat(data_x, 1, size(data_x, 1)), 1) ... 
        ./ sum(diff_matrix, 1)) - data_x;
    
    prev_data_x = data_x;
    data_x = data_x + mean_shift_vector;
    data_x = sort(data_x);

    % detect if the clusters have reached equilibrium
    threshold_error = 0.001;
    is_equilibrium = (data_x - prev_data_x) < 0.001;
    itterationCount++;

    if sum(is_equilibrium, 1) == size(data_x, 1)
        itterationCount
        break;
    end

    end

hold on
scatter(data_x, data_x, 10, 'red')