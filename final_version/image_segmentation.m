function [final_images, final_class_images] = image_segmentation(image_m, class_image, pool1, pool2)

    I = image_m;

    Id = double(I) / 255;
    Id_norm = Id ./ repmat(sum(Id, 3), [1, 1, 3]);
    Ig = sum(I, 3) / 3;


    % Ig_cluster = edge_detection(Ig, gausswin(80, 6), false);

    norm_im = Id ./ repmat(sum(Id, 3), [1, 1, 3]);

    r_im = int64(norm_im(:, :, 1) .* 255);
    g_im = int64(norm_im(:, :, 2) .* 255);
    b_im = int64(norm_im(:, :, 3) .* 255);

    % figure(1112)
    % colormap(gray)
    % imagesc(b_im)

    edge_r = edge_detection(r_im, gausswin(5, 2));
    edge_r_back = mode(reshape(edge_r, 1, size(edge_r, 1) * size(edge_r, 2)));
    edge_r_back_remove = edge_r ~= edge_r_back;

    edge_g = edge_detection(g_im, gausswin(5, 2));
    edge_g_back = mode(reshape(edge_g, 1, size(edge_g, 1) * size(edge_g, 2)));
    edge_g_back_remove = edge_g ~= edge_g_back;

    edge_b = edge_detection(b_im, gausswin(5, 2));
    edge_b_back = mode(reshape(edge_b, 1, size(edge_b, 1) * size(edge_b, 2)));
    edge_b_back_remove = edge_b ~= edge_b_back;

    Ig_cluster = ceil((edge_r_back_remove + edge_g_back_remove + edge_b_back_remove) ./ 3);

    % figure(224222)
    % colormap(gray)
    % imagesc(edge_r)
    % figure(22420)
    % colormap(gray)
    % imagesc(edge_r_back_remove)

    % figure(2242112342)
    % colormap(gray)
    % imagesc(edge_g)
    % figure(22421)
    % colormap(gray)
    % imagesc(edge_g_back_remove)

    % figure(22421111)
    % colormap(gray)
    % imagesc(edge_b)
    % figure(22423)
    % colormap(gray)
    % imagesc(edge_b_back_remove)

    % figure(222222)
    % colormap(gray)
    % imagesc(Ig_cluster)

    % -----
    % first max_pooling the algorithm does; the lower this value, the more points
    % selected on the object (also the more noise incorporated)
    % - the downside is that the program will run MUCH slower
    max_pool_v1 = pool1;
    % -----
    % second max_pooling; this value has not been experimented with and staying at
    % 2 doesn't really improve or worsen the algorithm'
    max_pool_v2 = pool2;

    conv_pool_filter= [1, max_pool_v1;
                       0, 0;
                       1, max_pool_v2];

    [Ig_pool_5, total_image_reduction] = apply_conv_pool_sequence(Ig_cluster, conv_pool_filter);

    % draw_bumpmap(Ig_pool_5, 900);

    Ig_not_min_pool_5 = find_not_mins(Ig_pool_5);

    Ig_max_pool_5 = find_maxs(Ig_pool_5);

    Ig_min_pool_5 = find_mins(Ig_pool_5);


    [num_clusters, clustered] = linkclustering(Ig_not_min_pool_5);
    % figure(int64(400 * rand(1)))
    % imagesc(clustered)
    Ig_not_min_pool_5 = clustered;

    [Ig_final_not_mins, Ig] = scale_image(Ig_not_min_pool_5, Ig);
    [Ig_final_maxims] = scale_image(Ig_max_pool_5, Ig);
    [Ig_final_mins] = scale_image(Ig_min_pool_5, Ig);

    % figure(20056)
    % colormap(gray)
    % imagesc(Ig_final_maxims);

    % figure(20751)
    % colormap(gray)
    % imagesc(Ig_final_not_mins);

    % figure(int64(20572 * rand(1)))
    % colormap(gray)
    % imagesc(Ig_final_not_mins + Ig);

    final_images = {};
    final_class_images = {};

    for i=1:(num_clusters - 1)
        % figure(13 + i)
        im_cluster = Ig .* (Ig_final_not_mins == i);
        [im_bounded, b_left, b_right, b_top, b_bottom] = minimum_bounding_box(im_cluster);
        % im_bounded = minimum_bounding_box(im_cluster);
        final_im = Id(b_left:b_right, b_top:b_bottom, :);

        final_images{i} = final_im;
        final_class_images{i} = class_image(b_left:b_right, b_top:b_bottom, :);
    end

end
