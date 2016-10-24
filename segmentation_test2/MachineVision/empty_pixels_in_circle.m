function [circ_compare] = empty_pixels_in_circle(binary_image)

    circ_radius = min(size(binary_image, 1), size(binary_image, 2)) / 4;

    image_centre = centre_of_mass(binary_image); %size(binary_image) ./ 2;

    x_grid = repmat([1:size(binary_image, 2)], size(binary_image, 1), 1);
    y_grid = repmat(transpose([1:size(binary_image, 1)]), 1, size(binary_image, 2));

    x_diff = x_grid - repmat(image_centre(1), size(binary_image, 1), size(binary_image, 2));
    y_diff = y_grid - repmat(image_centre(2), size(binary_image, 1), size(binary_image, 2));

    xy_diff = sqrt(x_diff .^ 2 + y_diff .^ 2);

    diff_binary = xy_diff < circ_radius;

    black_pixels_in_circle = sum(sum(diff_binary .* (binary_image == 0), 1));
    white_pixels_in_cricle = sum(sum(diff_binary .* binary_image, 1));
    total_pixels_in_circle = sum(sum(diff_binary, 1));

    circ_compare = black_pixels_in_circle ./ total_pixels_in_circle;

    % circ_compare = sum(sum(diff_binary .* binary_image, 1)) ./ sum(sum(binary_image, 1));

end