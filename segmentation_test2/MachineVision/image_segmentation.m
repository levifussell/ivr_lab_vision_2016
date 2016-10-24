function [final_images] = image_segmentation(image_m, pool1, pool2)

    I = image_m;

    Id = double(I) / 255;
    Id_norm = Id ./ repmat(sum(Id, 3), [1, 1, 3]);
    Ig = sum(I, 3) / 3;


    % Ig_cluster = edge_detection(Ig, gausswin(80, 6), false);

    norm_im = Id ./ repmat(sum(Id, 3), [1, 1, 3]);

    r_im = int64(norm_im(:, :, 1) .* 255);
    g_im = int64(norm_im(:, :, 2) .* 255);
    b_im = int64(norm_im(:, :, 3) .* 255);

    % figure(i * 1040)
    % colormap(gray)
    % imagesc(b_im)

    edge_r = edge_detection(r_im, gausswin(5, 2), false);
    Ig_cluster = (edge_r > 200);

    % -----
    % first max_pooling the algorithm does; the lower this value, the more points
    % selected on the object (also the more noise incorporated) 
    % - the downside is that the program will run MUCH slower
    max_pool_v1 = pool1; 
    % -----
    % second max_pooling; this value has not been experimented with and staying at
    % 2 doesn't really improve or worsen the algorithm
    max_pool_v2 = pool2;

    conv_pool_filter= [1, max_pool_v1;
                        0, 0;
                        1, max_pool_v2];

    [Ig_pool_5, total_image_reduction] = apply_conv_pool_sequence(Ig_cluster, conv_pool_filter);

    draw_bumpmap(Ig_pool_5, 900);

    Ig_not_min_pool_5 = find_not_mins(Ig_pool_5);

    Ig_max_pool_5 = find_maxs(Ig_pool_5);

    Ig_min_pool_5 = find_mins(Ig_pool_5);


    [num_clusters, clustered] = linkclustering(Ig_not_min_pool_5);
    figure(400)
    colormap(gray)
    imagesc(clustered)
    Ig_not_min_pool_5 = clustered;

    Ig_final_not_mins = scale_image(Ig_not_min_pool_5, Ig, total_image_reduction);
    Ig_final_maxims = scale_image(Ig_max_pool_5, Ig, total_image_reduction);
    Ig_final_mins = scale_image(Ig_min_pool_5, Ig, total_image_reduction);

    figure(20056)
    colormap(gray)
    imagesc(Ig_final_maxims);

    figure(20751)
    colormap(gray)
    imagesc(Ig_final_not_mins);

    figure(20572)
    colormap(gray)
    imagesc(Ig_final_mins);

    final_images = {};

    for i=1:(num_clusters - 1)
        % figure(13 + i)
        im_cluster = Ig .* (Ig_final_not_mins == i);
        [im_bounded, b_left, b_right, b_top, b_bottom] = minimum_bounding_box(im_cluster);
        % im_bounded = minimum_bounding_box(im_cluster);
        final_im = Id(b_left:b_right, b_top:b_bottom, :);
        
        final_images{i} = final_im;
    end

end