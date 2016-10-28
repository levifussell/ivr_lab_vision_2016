function [feature_vec, feature_image, full_image_chunk] = get_object_feature_vector(m_image, class_image, i, break_points)
% given an image and a class image, this function will return a feature
% vector that represents that object based on predefined built-in features

    if nargin < 4
        break_points = false;
    elseif nargin == 1
        class_image = m_image;
    end

    % normalise the image
    norm_im = m_image ./ repmat(sum(m_image, 3), [1, 1, 3]);

    % seperate the R, G, B components and convert to bytes
    r_im = int64(norm_im(:, :, 1) .* 255);
    g_im = int64(norm_im(:, :, 2) .* 255);
    b_im = int64(norm_im(:, :, 3) .* 255);

    if break_points

        figure(30)
        colormap(gray)
        imagesc(r_im)
        figure(31)
        colormap(gray)
        imagesc(g_im)
        figure(32)
        colormap(gray)
        imagesc(b_im)
        input('R, G, B normalised matrices of segment. continue?');

    end

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
    
    if break_points

        figure(30)
        colormap(gray)
        imagesc(r_im)
        figure(31)
        colormap(gray)
        imagesc(g_im)
        figure(32)
        colormap(gray)
        imagesc(b_im)
        input('R, G, B max-pooling with 2x2. continue?');
        figure(30)
        colormap(gray)
        imagesc(edge_r)
        figure(31)
        colormap(gray)
        imagesc(edge_g)
        figure(32)
        colormap(gray)
        imagesc(edge_b)
        input('threshold and remove background to make binary. continue?');

    end

    % create a shared binary image and remove any more noise via mode
    % colour
    edge_binary = edge_r + edge_g + edge_b;
    edge_binary = edge_binary - mode(reshape(edge_binary, 1, size(edge_binary, 1) * size(edge_binary, 2)));
    % find the minimum-bounding box of the binary image
    [box_f, l, r, t, b] = minimum_bounding_box(edge_binary > 0);
    
    if break_points
        figure(33)
        colormap(gray)
        imagesc(box_f)
        input('final merged R, G, B binary image. continue?');
    end

    % scale the binary image to the original ratio and convert the current
    % image to the new shared ratio
    [scl_binary, m_image_new] = scale_image(edge_binary, m_image(:, :, 1));
    m_image = m_image(1:size(m_image_new, 1), 1:size(m_image_new, 2), :);
    %extract the object from the rest of the image by overlaying the binary
    %image onto the original object image
    im_subtr = m_image(1:size(scl_binary, 1), 1:size(scl_binary, 2), :);
    
    % save the image bounding box with full detail
    full_image_chunk = im_subtr;
    
    %subtract image
    im_subtr = im_subtr .* repmat(scl_binary, [1, 1, 3]);
    
    if break_points
        figure(33)
        colormap(gray)
        imagesc(im_subtr)
        input('scale and merge binary image with main image. continue?');
    end

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
    % area = bwarea(box_f);
    % perim = bwarea(bwperim(box_f, 4));
    % feature_vec(1, 5) = perim*perim/(4*pi*area);
    feature_vec(1, 5) = 1;

    if break_points
        text(5, 5, strcat(['f1 - circle comparison: ', num2str(feature_vec(1, 1))]), 'color', 'red')
        text(5, 10, strcat(['f2 - hole value: ', num2str(feature_vec(1, 2))]), 'color', 'red')
        text(5, 15, strcat(['f3 - average colour: ', num2str(feature_vec(1, 3))]), 'color', 'red')
        text(5, 20, strcat(['f4 - density: ', num2str(feature_vec(1, 4))]), 'color', 'red')
        text(5, 25, strcat(['f5 - compactness: ', num2str(feature_vec(1, 5))]), 'color', 'red')
        input('scale and merge binary image with main image. continue?');
    end

    feature_image = box_f;

end