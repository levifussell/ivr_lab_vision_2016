function [feature_vec, feature_image] = get_object_feature_vector(m_image, class_image, i)
% given an image and a class image, this function will return a feature
% vector that represents that object based on predefined built-in features


    % normalise the image
    norm_im = m_image ./ repmat(sum(m_image, 3), [1, 1, 3]);

    % seperate the R, G, B components and convert to bytes
    r_im = int64(norm_im(:, :, 1) .* 255);
    g_im = int64(norm_im(:, :, 2) .* 255);
    b_im = int64(norm_im(:, :, 3) .* 255);

    % for each R, G, and B channel, perform max pooling to remove image
    % noise
    r_im = max_pooling(r_im, 2);
    % use edge detection and thresholds to simplify the image colours
    edge_r = edge_detection(r_im, gausswin(2, 1));
    % remove the mode colour (most common colour) for background removal
    edge_r_back = mode(reshape(edge_r, 1, size(edge_r, 1) * size(edge_r, 2)));
    edge_r = edge_r ~= edge_r_back;
    
    %---
    g_im = max_pooling(g_im, 2);
    edge_g = edge_detection(g_im, gausswin(2, 1));
    edge_g_back = mode(reshape(edge_g, 1, size(edge_g, 1) * size(edge_g, 2)));
    edge_g = edge_g ~= edge_g_back;

    %---
    b_im = max_pooling(b_im, 2);
    edge_b = edge_detection(b_im, gausswin(2, 1));
    edge_b_back = mode(reshape(edge_b, 1, size(edge_b, 1) * size(edge_b, 2)));
    edge_b = edge_b ~= edge_b_back;
    
    % create a shared binary image and remove any more noise via mode
    % colour
    edge_binary = edge_r + edge_g + edge_b;
    edge_binary = edge_binary - mode(reshape(edge_binary, 1, size(edge_binary, 1) * size(edge_binary, 2)));
    % find the minimum-bounding box of the binary image
    [box_f, l, r, t, b] = minimum_bounding_box(edge_binary > 0);

    % scale the binary image to the original ratio and convert the current
    % image to the new shared ratio
    [scl_binary, m_image_new] = scale_image(edge_binary, m_image(:, :, 1));
    m_image = m_image(1:size(m_image_new, 1), 1:size(m_image_new, 2), :);
    %extract the object from the rest of the image by overlaying the binary
    %image onto the original object image
    im_subtr = m_image(1:size(scl_binary, 1), 1:size(scl_binary, 2), :);
    im_subtr = im_subtr .* repmat(scl_binary, [1, 1, 3]);

    % get the average colour of the subtracted object for a classification
    % feature
    color_avg = reshape(sum(sum(im_subtr, 1)) ./ sum(sum(scl_binary, 1)), 1, 3);

    % define a feature vector for the object
    feature_vec = zeros(1, 5);

    % feat 1: how similar the object is to a circle
    feature_vec(1, 1) = circle_comparison(box_f);
    % feat 2: how much of a hole the object has
    feature_vec(1, 2) = empty_pixels_in_circle(box_f);
    % feat 3: the hashed value of the objects average colour
    feature_vec(1, 3) = color_avg(1) + (color_avg(2) + 1) .^ 2 + (color_avg(3) + 2) .^ 3;
    % feat 4: the density of the white pixels in the object image
    feature_vec(1, 4) = density_of_image(box_f);
    % feat 5: the compression of the object
    area = bwarea(box_f);
    perim = bwarea(bwperim(box_f, 4));
    feature_vec(1, 5) = perim*perim/(4*pi*area);

    feature_image = box_f;

end