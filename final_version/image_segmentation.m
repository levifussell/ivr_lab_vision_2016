function [final_images, final_class_images] = image_segmentation(image_m, class_image, pool1, pool2)
% given an image, a training class image and 2 max-pooling values, perform
% image segmentation via blob-analysis and attempt to remove blobs as
% individual minimum-bounding boxes

    I = image_m;

    Id = double(I) / 255;
    % greyscale the image
    Id_norm = Id ./ repmat(sum(Id, 3), [1, 1, 3]);
    
    Ig = sum(image_m, 3) / 3;
    % normalise the image
    norm_im = Id ./ repmat(sum(Id, 3), [1, 1, 3]);

    % take the seperate R, G, and B matrices of the image
    r_im = int64(norm_im(:, :, 1) .* 255);
    g_im = int64(norm_im(:, :, 2) .* 255);
    b_im = int64(norm_im(:, :, 3) .* 255);

    % perform edge detection on each R, G, and B matrix
    edge_r = edge_detection(r_im, gausswin(5, 2));
    % remove the background by finding the most common colour
    edge_r_back = mode(reshape(edge_r, 1, size(edge_r, 1) * size(edge_r, 2)));
    edge_r_back_remove = edge_r ~= edge_r_back;

    edge_g = edge_detection(g_im, gausswin(5, 2));
    edge_g_back = mode(reshape(edge_g, 1, size(edge_g, 1) * size(edge_g, 2)));
    edge_g_back_remove = edge_g ~= edge_g_back;

    edge_b = edge_detection(b_im, gausswin(5, 2));
    edge_b_back = mode(reshape(edge_b, 1, size(edge_b, 1) * size(edge_b, 2)));
    edge_b_back_remove = edge_b ~= edge_b_back;

    % perform binary OR on R, G, and B to get a full edge image              
    Ig_edged = ceil((edge_r_back_remove + edge_g_back_remove + edge_b_back_remove) ./ 3);

    % perform a sequence of max-pooling and guassian convolution filters
    conv_pool_filter= [0, 0; 
                        1, pool1;
                       1, pool2];

    [filtered_I, total_image_reduction] = apply_conv_pool_sequence(Ig_edged, conv_pool_filter);

    % cluster the blobs using linkclustering
    [num_clusters, clustered] = linkclustering(filtered_I);

    % scale the image back to the original size (scaled due to convolutions
    % and max-pooling)
    [scaled_filtered_I, Ig] = scale_image(clustered, Ig);

    final_images = {};
    final_class_images = {};

    % itterate through each cluster
    for i=1:(num_clusters)
        % figure(13 + i)
        % get the cluster
        im_cluster = Ig .* (scaled_filtered_I == i);
        % get the minimum-bounding box of the cluster
        [im_bounded, b_left, b_right, b_top, b_bottom] = minimum_bounding_box(im_cluster);
        % im_bounded = minimum_bounding_box(im_cluster);
        
        % take the bounding box from the original image
        final_images{i} = Id(b_left:b_right, b_top:b_bottom, :);
        
        % take the bounding box from the training image
        final_class_images{i} = class_image(b_left:b_right, b_top:b_bottom, :);
    end

end
