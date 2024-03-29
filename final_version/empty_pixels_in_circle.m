function [circ_compare] = empty_pixels_in_circle(binary_image)
% given a binary image, this function will calculate the percentage of
% black pixels in a small sub-circle centred in the image. It is assumed
% the image is a minimum-bounding box

    % create a circle half the size of the smallest dimension
    circ_radius = min(size(binary_image, 1), size(binary_image, 2)) / 4;

    image_centre = centre_of_mass(binary_image); %size(binary_image) ./ 2;

    % create a grid of differences to the centre on the image
    x_grid = repmat([1:size(binary_image, 2)], size(binary_image, 1), 1);
    y_grid = repmat(transpose([1:size(binary_image, 1)]), 1, size(binary_image, 2));
    x_diff = x_grid - repmat(image_centre(1), size(binary_image, 1), size(binary_image, 2));
    y_diff = y_grid - repmat(image_centre(2), size(binary_image, 1), size(binary_image, 2));
    xy_diff = sqrt(x_diff .^ 2 + y_diff .^ 2);
    
    % find all differences less than the radius (in the circle)
    diff_binary = xy_diff < circ_radius;

    % calculate percentage of black pixels in the sub-circle
    black_pixels_in_circle = sum(sum(diff_binary .* (binary_image == 0), 1));
    total_pixels_in_circle = sum(sum(diff_binary, 1));

    circ_compare = (black_pixels_in_circle + 1) ./ (total_pixels_in_circle + 1);
end