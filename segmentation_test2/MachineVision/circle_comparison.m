function [circ_compare] = circle_comparison(binary_image)

    circ_radius = min(size(binary_image, 1), size(binary_image, 2)) / 2;

    image_centre = size(binary_image) ./ 2;

    x_grid = repmat([1:size(binary_image, 2)], size(binary_image, 1), 1);
    y_grid = repmat(transpose([1:size(binary_image, 1)]), 1, size(binary_image, 2));

    x_diff = x_grid - repmat(image_centre(1), size(binary_image, 1), size(binary_image, 2));
    y_diff = y_grid - repmat(image_centre(2), size(binary_image, 1), size(binary_image, 2));

    xy_diff = sqrt(x_diff .^ 2 + y_diff .^ 2);

    diff_binary = xy_diff < circ_radius;

    circ_compare = sum(sum(diff_binary .* binary_image, 1)) ./ sum(sum(binary_image, 1));

end