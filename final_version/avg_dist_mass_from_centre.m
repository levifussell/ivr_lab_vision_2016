function [avg_dist] = avg_dist_mass_from_centre(binary_image)

    image_centre = centre_of_mass(binary_image);%size(binary_image) ./ 2;

    x_grid = repmat([1:size(binary_image, 2)], size(binary_image, 1), 1);
    y_grid = repmat(transpose([1:size(binary_image, 1)]), 1, size(binary_image, 2));

    x_diff = x_grid - repmat(image_centre(1), size(binary_image, 1), size(binary_image, 2));
    y_diff = y_grid - repmat(image_centre(2), size(binary_image, 1), size(binary_image, 2));

    xy_diff = sqrt(x_diff .^ 2 + y_diff .^ 2);

    avg_dist = sum(sum(xy_diff .* binary_image, 1)) ./ sum(sum(binary_image, 1));

end