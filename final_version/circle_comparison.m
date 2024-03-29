function [circ_compare] = circle_comparison(binary_image)
% given a binary image, this function calculates the ratio of white pixels
% that are within the maximum-bounding circle of the binary image

    % circle defined by the smallest dimension
    circ_radius = min(size(binary_image, 1), size(binary_image, 2)) / 2;

    image_centre = size(binary_image) ./ 2;

    % create a grid of differences to the centre of the image
    x_grid = repmat([1:size(binary_image, 2)], size(binary_image, 1), 1);
    y_grid = repmat(transpose([1:size(binary_image, 1)]), 1, size(binary_image, 2));
    x_diff = x_grid - repmat(image_centre(1), size(binary_image, 1), size(binary_image, 2));
    y_diff = y_grid - repmat(image_centre(2), size(binary_image, 1), size(binary_image, 2));
    xy_diff = sqrt(x_diff .^ 2 + y_diff .^ 2);

    % find all differences that are less than the radius of the circle
    % (inside the circle)
    diff_binary = xy_diff < circ_radius;

    % calculate the ratio of white pixels in the circle to total white
    % pixels
    num_white_pixels_in_circle = sum(sum(diff_binary .* binary_image, 1));
    num_total_white_pixels = sum(sum(binary_image, 1));
    
    circ_compare = num_white_pixels_in_circle ./ num_total_white_pixels;

end