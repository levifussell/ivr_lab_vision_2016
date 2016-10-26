function [hash_val] = hash_rgb(rgb_m)

    if size(rgb_m, 3) ~= 1
        hash_val = rgb_m(:, :, 1) + (rgb_m(:, :, 2) + 255) .^ 2 + (rgb_m(:, :, 3) + 510) .^ 3;
    else
        hash_val = rgb_m(1) + (rgb_m(2) + 255) .^ 2 + (rgb_m(3) + 510) .^ 3;
    end
end