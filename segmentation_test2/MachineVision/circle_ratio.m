function [c_ratio] = circle_ratio(binary_image)

    radius = min(size(binary_image, 1), size(binary_image, 2)) / 2;
    circle_area = 3.141 .* (radius .^ 2);

    c_ratio = sum(sum(binary_image, 1)) ./ circle_area;

end