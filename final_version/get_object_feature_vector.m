function [feature_vec, feature_image] = get_object_feature_vector(m_image, class_image, i)

    % figure(i)
    % imagesc(m_image)

    norm_im = m_image ./ repmat(sum(m_image, 3), [1, 1, 3]);

    r_im = int64(norm_im(:, :, 1) .* 255);
    g_im = int64(norm_im(:, :, 2) .* 255);
    b_im = int64(norm_im(:, :, 3) .* 255);

%     figure(i * 1340)
%     colormap(gray)
%     imagesc(r_im)
%     figure(i * 1042)
%     colormap(gray)
%     imagesc(g_im)
%     figure(i * 10992)
%     colormap(gray)
%     imagesc(b_im)

    r_im = max_pooling(r_im, 2);

    edge_r = edge_detection(r_im, gausswin(2, 1), false);
    % figure(1000 * i)
    % colormap(gray)
    % imagesc(edge_r);
    edge_r_back = mode(reshape(edge_r, 1, size(edge_r, 1) * size(edge_r, 2)));
    edge_r = edge_r ~= edge_r_back;
    
    g_im = max_pooling(g_im, 2);

    edge_g = edge_detection(g_im, gausswin(2, 1), false);
    % figure(1201 * i)
    % colormap(gray)
    % imagesc(edge_g);
    edge_g_back = mode(reshape(edge_g, 1, size(edge_g, 1) * size(edge_g, 2)));
    edge_g = edge_g ~= edge_g_back;

    b_im = max_pooling(b_im, 2);

    edge_b = edge_detection(b_im, gausswin(2, 1), false);
    % figure(1021 * i)
    % colormap(gray)
    % imagesc(edge_b);
    edge_b_back = mode(reshape(edge_b, 1, size(edge_b, 1) * size(edge_b, 2)));
    edge_b = edge_b ~= edge_b_back;

    % edge_total = (edge_b + edge_r) > 0; %((edge_r + edge_b + edge_g) ./ 3);
    % box_f = minimum_bounding_box(edge_total);
    % figure(1429 * i)
    % colormap(gray)
    % imagesc(box_f)
    edge_total = zeros(size(edge_b, 1), size(edge_b, 2), 3);
    edge_total(:, :, 1) = edge_r; %- mode(reshape(edge_r, 1, size(edge_r, 1) * size(edge_r, 2)));
    edge_total(:, :, 2) = edge_g; %- mode(reshape(edge_g, 1, size(edge_g, 1) * size(edge_g, 2)));;
    edge_total(:, :, 3) = edge_b; %- mode(reshape(edge_b, 1, size(edge_b, 1) * size(edge_b, 2)));;
    edge_binary = sum(edge_total, 3);
    edge_binary = edge_binary - mode(reshape(edge_binary, 1, size(edge_binary, 1) * size(edge_binary, 2)));
    [box_f, l, r, t, b] = minimum_bounding_box(edge_binary > 0);
    % figure(int64(1429 * rand(1)))
    % colormap(gray)
    % imagesc(box_f)
    
    % box_f_blur = apply_conv_pool_sequence(box_f, [0, 0]);

    % box_f_mins = find_mins(box_f);
    % figure(112 * i)
    % colormap(gray)
    % imagesc(box_f_mins)
    % draw_bumpmap(box_f .* 2 - 1, i * 55395);

    [scl_binary, m_image_new] = scale_image(edge_binary, m_image(:, :, 1));
    m_image = m_image(1:size(m_image_new, 1), 1:size(m_image_new, 2), :);
    im_subtr = m_image(1:size(scl_binary, 1), 1:size(scl_binary, 2), :);
    im_subtr = im_subtr .* repmat(scl_binary, [1, 1, 3]);
    % figure(int64(11982 * rand(1)))
    % imagesc(im_subtr);
    color_avg = reshape(sum(sum(im_subtr, 1)) ./ sum(sum(scl_binary, 1)), 1, 3);

    % edges = linspace(0, 1, 255);
    % vec_i = reshape(norm_im(:, :, 3), 1, size(norm_im(:, :, 3), 1) * size(norm_im(:, :, 3), 2));
    % hist_i = histc(vec_i, edges);
    % filter = gausswin(10, 1);
    % filter = filter/sum(filter);
    % hist_i = conv(hist_i, filter);
    % figure(1000 * i);
    % plot(hist_i);

    % obj_data{1 + i, 1} = centre_of_mass(box_f);
    % obj_data{1 + i, 2} = circle_ratio(box_f);
    % obj_data{1 + i, 3} = circle_comparison(box_f);
    % obj_data{1 + i, 4} = avg_dist_mass_from_centre(box_f);
    % obj_data{1 + i, 5} = empty_pixels_in_circle(box_f);
    % obj_data{1 + i, 6} = color_avg(1) + (color_avg(2) + 1) .^ 2 + (color_avg(3) + 2) .^ 3;

    feature_vec = zeros(1, 3);

    feature_vec(1, 1) = circle_comparison(box_f);
    feature_vec(1, 2) = empty_pixels_in_circle(box_f);
    feature_vec(1, 3) = color_avg(1) + (color_avg(2) + 1) .^ 2 + (color_avg(3) + 2) .^ 3;

    feature_image = box_f;
    % feature_vec(1, 4) = density_of_image(box_f);

end