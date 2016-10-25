function [c_of_m] = centre_of_mass(binary_image)

    one_over_area = 1 ./ sum(sum(binary_image, 1));

    r_c = sum(transpose([1:size(binary_image, 1)]) .* sum(binary_image, 2), 1) .* one_over_area;
    c_c = sum([1:size(binary_image, 2)] .* sum(binary_image, 1), 2) .* one_over_area;

    c_of_m = [r_c, c_c];
end