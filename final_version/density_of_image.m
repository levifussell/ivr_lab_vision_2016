function [density] = density_of_image(image_m)
    
    % density = mass / volume

    mass_v = sum(sum(image_m, 1));
    volume_v = size(image_m, 1) * size(image_m, 2);
    density = mass_v ./ volume_v;

end