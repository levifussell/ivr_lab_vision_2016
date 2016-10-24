function [m_clustered] = hillCluster(m_image)

    % find maximums of image
    a_x = Ig_pool_5 >= ([ones(size(m_image, 1), 1) .* 1000, m_image(:, 1:(size(m_image, 2) - 1))]);
    b_x = Ig_pool_5 >= ([m_image(:, 2:size(m_image, 2)), ones(size(m_image, 1), 1) .* 1000]);
    a_y = Ig_pool_5 >= ([ones(1, size(m_image, 2)) .* 1000; m_image(1:(size(m_image, 1) - 1), :)]);
    b_y = Ig_pool_5 >= ([m_image(2:size(m_image, 1), :); ones(1, size(m_image, 2)) .* 1000]);
    m_image_maximums = a_x .* b_x .* a_y .* b_y .* m_image;

    

end