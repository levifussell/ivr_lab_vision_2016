% % unix('mplayer tv:// -tv driver=v4l2:width=140:height=140:device=/dev/video1 -frames 1 -vo jpeg');

I = imread('06.jpg');

figure(143412)
imagesc(I)

% Id = double(I) ./ 255;

% norm_im = Id ./ repmat(sum(Id, 3), [1, 1, 3]);

% r_im = int64(norm_im(:, :, 1) .* 255);
% g_im = int64(norm_im(:, :, 2) .* 255);
% b_im = int64(norm_im(:, :, 3) .* 255);

% % figure(i * 1040)
% % colormap(gray)
% % imagesc(b_im)

% edge_r = edge_detection(r_im, gausswin(5, 2), false);
% edge_off = (edge_r > 200);

% conv_pool_filter= [1, 7;
%                     0, 0;
%                     1, 2];

% [edge_pool, total_image_reduction] = apply_conv_pool_sequence(edge_off, conv_pool_filter);

% figure(2)
% colormap(gray)
% imagesc(edge_pool > 0.3);
% edge_g = edge_detection(g_im, gausswin(5, 2), false);
% figure(3)
% colormap(gray)
% imagesc(edge_g);
% edge_b = edge_detection(b_im, gausswin(5, 2), false);
% figure(4)
% colormap(gray)
% imagesc(edge_b);

final_images = image_segmentation(I, 7, 2);

obj_data = {};
obj_data{1, 1} = 'COM';
obj_data{1, 2} = 'CIRC. RATIO';
obj_data{1, 3} = '# IN CIRC';
obj_data{1, 4} = 'avg. dist. mass';
obj_data{1, 5} = '# black pxls in circle';
obj_data{1, 6} = 'avg. color';

obj_vectors = zeros(size(final_images, 1), 2);

for i=1:size(final_images, 2)

    % edge_im = edge_detection(final_images{i});
    % max_pool_v1 = 2; 
    % max_pool_v2 = 2;

    % conv_pool_filter= [0, 0;
    %                     1, max_pool_v2];

    % [ig_pool, total_image_reduction] = apply_conv_pool_sequence(final_images{i}, conv_pool_filter);

    % final_images_sub = image_segmentation(final_images{i}, 1, 1);

    % for j=1:size(final_images_sub, 2)

    %     % edge_im = edge_detection(final_images{i});
    %     % max_pool_v1 = 2; 
    %     % max_pool_v2 = 2;

    %     % conv_pool_filter= [0, 0;
    %     %                     1, max_pool_v2];

    %     % [ig_pool, total_image_reduction] = apply_conv_pool_sequence(final_images{i}, conv_pool_filter);

        

    %     figure(i * 100 + j)
    %     colormap(gray)
    %     imagesc(final_images_sub{j})

    % end

    % Ig_edge = edge_detection(final_images{i});

    % conv_pool_filter= [1, 7
    %                     0, 0;
    %                     1, 2];

    % [im_clust, total_image_reduction] = apply_conv_pool_sequence(final_images{i}, conv_pool_filter);

    % draw_bumpmap(im_clust, 900 + i);

    % Ig_min_pool_5 = find_mins(im_clust);

    % figure(10000 + i)
    % colormap(gray)
    % imagesc(Ig_min_pool_5)

    figure(i)
    imagesc(final_images{i})

    norm_im = final_images{i} ./ repmat(sum(final_images{i}, 3), [1, 1, 3]);

    r_im = int64(norm_im(:, :, 1) .* 255);
    g_im = int64(norm_im(:, :, 2) .* 255);
    b_im = int64(norm_im(:, :, 3) .* 255);

    % figure(i * 1040)
    % colormap(gray)
    % imagesc(b_im)

    r_im = max_pooling(r_im, 2);

    edge_r = edge_detection(r_im, gausswin(5, 2), false);
    % figure(1000 * i)
    % colormap(gray)
    edge_r = edge_r > 50;
    % imagesc(edge_r);
    
    g_im = max_pooling(g_im, 2);

    edge_g = edge_detection(g_im, gausswin(5, 2), false);
    % figure(1201 * i)
    % colormap(gray)
    edge_g = edge_g > 150;
    % imagesc(edge_g);

    b_im = max_pooling(b_im, 2);

    edge_b = edge_detection(b_im, gausswin(5, 2), false);
    % figure(1021 * i)
    % colormap(gray)
    edge_b = edge_b < 200;
    % imagesc(edge_b);

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
    figure(1429 * i)
    colormap(gray)
    imagesc(box_f)
    
    % box_f_blur = apply_conv_pool_sequence(box_f, [0, 0]);

    % box_f_mins = find_mins(box_f);
    % figure(112 * i)
    % colormap(gray)
    % imagesc(box_f_mins)
    % draw_bumpmap(box_f .* 2 - 1, i * 55395);

    scl_binary = scale_image(edge_binary, final_images{i}(:, :, 1), 2);
    im_subtr = final_images{i}(1:size(scl_binary, 1), 1:size(scl_binary, 2), :);
    im_subtr = im_subtr .* repmat(scl_binary, [1, 1, 3]);
    figure(112 * i)
    imagesc(im_subtr);
    color_avg = reshape(sum(sum(im_subtr, 1)) ./ sum(sum(scl_binary, 1)), 1, 3);

    % edges = linspace(0, 1, 255);
    % vec_i = reshape(norm_im(:, :, 3), 1, size(norm_im(:, :, 3), 1) * size(norm_im(:, :, 3), 2));
    % hist_i = histc(vec_i, edges);
    % filter = gausswin(10, 1);
    % filter = filter/sum(filter);
    % hist_i = conv(hist_i, filter);
    % figure(1000 * i);
    % plot(hist_i);

    obj_data{1 + i, 1} = centre_of_mass(box_f);
    obj_data{1 + i, 2} = circle_ratio(box_f);
    obj_data{1 + i, 3} = circle_comparison(box_f);
    obj_data{1 + i, 4} = avg_dist_mass_from_centre(box_f);
    obj_data{1 + i, 5} = empty_pixels_in_circle(box_f);
    obj_data{1 + i, 6} = color_avg(1) + (color_avg(2) + 1) .^ 2 + (color_avg(3) + 2) .^ 3;

    obj_vectors(i, 1) = obj_data{1 + i, 3};
    obj_vectors(i, 2) = obj_data{1 + i, 5};
    obj_vectors(i, 3) = obj_data{1 + i, 6};
end

scatter3(obj_vectors(:, 1), obj_vectors(:, 2), obj_vectors(:, 3));

% 0: 1GBP
% 1: 2GBP
% 2: 50p
% 3: 20p
% 4: 5p
% 5: Wash. Small Hole
% 6: Wash. Large Hole
% 7: Angle
% 8: Battery
% 9: Nut

% Id = double(I) / 255;
% Id_norm = Id ./ repmat(sum(Id, 3), [1, 1, 3]);
% Ig = sum(I, 3) / 3;

% % figure(5)
% % % colormap(gray)
% % imagesc(Id_norm)

% % Ig = max_pooling(Ig, 4);

% % figure(10)
% % colormap(gray)
% % imagesc(Ig)

% % hold on

% edges = [0:255];
% [rows, columns] = size(Ig);
% Ig_vec = reshape(Ig, 1, rows .* columns);

% I_hist = histc(Ig_vec, edges);

% % figure(2)
% % plot(I_hist);

% % hold on

% filter = gausswin(80, 6);
% filter = filter/sum(filter);
% % figure(3)
% % plot(filter)

% smooth_hist = conv(filter, I_hist);
% figure(1)
% plot(smooth_hist)

% hold on

% % find minimums betweenthresholds
% offset_error = 0;
% a = smooth_hist < ([10, smooth_hist(:, 1:(size(smooth_hist, 2) - 1))] - repmat(offset_error, 1, size(smooth_hist, 2)));
% b = smooth_hist < ([smooth_hist(:, 2:size(smooth_hist, 2)), 10] - repmat(offset_error, 1, size(smooth_hist, 2)));
% hist_maximums = a .* b .* smooth_hist;

% plot(hist_maximums, '*', 'markersize', 10)


% % I_bw = (Ig < 150);
% % figure(2)
% % colormap(gray)
% % imagesc(I_bw)

% % create a set of thresholds
% I_thresholds = find(hist_maximums > 0);
% I_num_thresholds = size(I_thresholds, 2);
% threshold_rate = 255 ./ I_num_thresholds;
% Ig_cluster = zeros(size(Ig));

% for i=1:I_num_thresholds

%     Ig_cluster += (Ig < I_thresholds(:, i)) .* threshold_rate;
% end

% figure(3)
% colormap(gray)
% imagesc(Ig_cluster)

% figure(4)
% colormap(gray)
% imagesc(Ig)

% % filter = [2 0 0; 0 0 0; 0 0 -2];
% % % filter = filter/sum(filter);
% % % figure(3)
% % % plot(filter)

% % Ig_cluster_smooth = conv2(filter, Ig_cluster);

% % figure(5)
% % colormap(gray)
% % imagesc(Ig_cluster_smooth)

% % -----
% % first max_pooling the algorithm does; the lower this value, the more points
% % selected on the object (also the more noise incorporated) 
% % - the downside is that the program will run MUCH slower
% max_pool_v1 = 7; 
% % -----
% % second max_pooling; this value has not been experimented with and staying at
% % 2 doesn't really improve or worsen the algorithm
% max_pool_v2 = 2;

% % -----
% % how much the image has been reduced in total
% % total_max_pooling_reduction = max_pool_v1 * max_pool_v2;

% % Ig_pool_3 = max_pooling(Ig_cluster, max_pool_v1);

% % figure(6)
% % colormap(gray)
% % imagesc(Ig_pool_3)

% % % -----
% % % after the first max-pooling, the algorithm blurs the image so that there are less
% % %  distinct pixels. It then proceeds to half the image again with another max-pooling
% % filter =    [1 4 7 4 1; 
% %             4 16 36 16 4; 
% %             7 26 41 26 7; 
% %             4 16 26 16 4; 
% %             1 4 7 4 1] ./ 273;
% % % filter =    [16 36 16; 
% % %             26 41 26; 
% % %             16 26 16] ./ 273;
% % % filter = [16 36 16; 26 41 26; 16 26 16] ./ 273;
% % % filter = [0 0 0; 0 1 0; 0 0 0];
% % Ig_smooth_4 = conv2(Ig_pool_3, filter);

% % % Ig_smooth_reduction = (size(Ig_smooth_4) - size(Ig_pool_3)) / 2;
% % % Ig_smooth_4 = Ig_smooth_4(Ig_smooth_reduction:(size(Ig_smooth_4, 1) - Ig_smooth_reduction - 1),
% % %                             Ig_smooth_reduction:(size(Ig_smooth_4, 2) - Ig_smooth_reduction - 1));

% % figure(7)
% % colormap(gray)
% % imagesc(Ig_smooth_4)

% % Ig_pool_5 = max_pooling(Ig_smooth_4, max_pool_v2);

% % figure(8)
% % colormap(gray)
% % imagesc(Ig_pool_5)
% conv_pool_filter= [1, max_pool_v1;
%                     0, 0;
%                     1, max_pool_v2];

% [Ig_pool_5, total_image_reduction] = apply_conv_pool_sequence(Ig_cluster, conv_pool_filter);

% % draw_bumpmap(Ig_pool_5, 9);

% % % find ONLY mins
% % a_x = Ig_pool_5 < ([ones(size(Ig_pool_5, 1), 1) .* 1000, Ig_pool_5(:, 1:(size(Ig_pool_5, 2) - 1))]);
% % b_x = Ig_pool_5 < ([Ig_pool_5(:, 2:size(Ig_pool_5, 2)), ones(size(Ig_pool_5, 1), 1) .* 1000]);
% % a_y = Ig_pool_5 < ([ones(1, size(Ig_pool_5, 2)) .* 1000; Ig_pool_5(1:(size(Ig_pool_5, 1) - 1), :)]);
% % b_y = Ig_pool_5 < ([Ig_pool_5(2:size(Ig_pool_5, 1), :); ones(1, size(Ig_pool_5, 2)) .* 1000]);
% % Ig_only_min_pool_5 = (a_x .* b_x .* a_y .* b_y);

% % find inverse minimums
% % a_x = Ig_pool_5 <= ([ones(size(Ig_pool_5, 1), 1) .* 1000, Ig_pool_5(:, 1:(size(Ig_pool_5, 2) - 1))]);
% % b_x = Ig_pool_5 <= ([Ig_pool_5(:, 2:size(Ig_pool_5, 2)), ones(size(Ig_pool_5, 1), 1) .* 1000]);
% % a_y = Ig_pool_5 <= ([ones(1, size(Ig_pool_5, 2)) .* 1000; Ig_pool_5(1:(size(Ig_pool_5, 1) - 1), :)]);
% % b_y = Ig_pool_5 <= ([Ig_pool_5(2:size(Ig_pool_5, 1), :); ones(1, size(Ig_pool_5, 2)) .* 1000]);
% % Ig_min_pool_5 = ((ceil((a_x .* b_x + a_y .* b_y) / 2) == 0)) .* Ig_pool_5;

% Ig_min_pool_5 = find_mins(Ig_pool_5);

% % find maximums
% % a_x = Ig_pool_5 >= ([ones(size(Ig_pool_5, 1), 1) .* 1000, Ig_pool_5(:, 1:(size(Ig_pool_5, 2) - 1))]);
% % b_x = Ig_pool_5 >= ([Ig_pool_5(:, 2:size(Ig_pool_5, 2)), ones(size(Ig_pool_5, 1), 1) .* 1000]);
% % a_y = Ig_pool_5 >= ([ones(1, size(Ig_pool_5, 2)) .* 1000; Ig_pool_5(1:(size(Ig_pool_5, 1) - 1), :)]);
% % b_y = Ig_pool_5 >= ([Ig_pool_5(2:size(Ig_pool_5, 1), :); ones(1, size(Ig_pool_5, 2)) .* 1000]);
% % Ig_max_pool_5 = a_x .* b_x .* a_y .* b_y .* Ig_pool_5;
% Ig_max_pool_5 = find_maxs(Ig_pool_5);


% % figure(10)
% % colormap(gray)
% % imagesc(Ig_min_pool_5)

% % figure(11)
% % colormap(gray)
% % imagesc(Ig_max_pool_5)

% [num_clusters, clustered] = linkclustering(Ig_min_pool_5);
% % figure(12)
% % colormap(gray)
% % imagesc(clustered)
% Ig_min_pool_5 = clustered;

% % re-expand the matrix
% % Ig_min_pool_5_expand = kron(Ig_min_pool_5, ones(total_image_reduction));
% % Ig_max_pool_5_expand = kron(Ig_max_pool_5, ones(total_image_reduction));


% % figure(11)
% % colormap(gray)
% % imagesc(Ig_max_pool_5_expand)

% Ig_final_mins = scale_image(Ig_min_pool_5, Ig, total_image_reduction);
% Ig_final_maxims = scale_image(Ig_max_pool_5, Ig, total_image_reduction);

% % loss_of_pizels = size(Ig_max_pool_5_expand) - size(Ig);
% % border_loss = loss_of_pizels / 2;
% % Ig_final_mins = Ig_min_pool_5_expand(border_loss(1):(size(Ig_min_pool_5_expand, 1) - border_loss(1) - 1), border_loss(2):(size(Ig_min_pool_5_expand, 2) - border_loss(2) - 1));
% % Ig_final_maxims = Ig_max_pool_5_expand(border_loss(1):(size(Ig_max_pool_5_expand, 1) - border_loss(1) - 1), border_loss(2):(size(Ig_max_pool_5_expand, 2) - border_loss(2) - 1));
% % Ig_final_maxims = [Ig_max_pool_5_expand, zeros(size(Ig_max_pool_5_expand, 1) + loss_of_pizels(1), loss_of_pizels(2)); 
% %                     zeros(loss_of_pizels(1), size(Ig_max_pool_5_expand, 2) + loss_of_pizels(2))];

% figure(13)
% colormap(gray)
% imagesc(Ig .* Ig_final_mins)

% im_color_avg = zeros(num_clusters - 1, 3);

% final_images = {};

% for i=1:(num_clusters - 1)
%     figure(13 + i)
%     im_cluster = Ig .* (Ig_final_mins == i);
%     [im_bounded, b_left, b_right, b_top, b_bottom] = minimum_bounding_box(im_cluster);
%     % im_bounded = minimum_bounding_box(im_cluster);
%     final_im = Ig(b_left:b_right, b_top:b_bottom);
    
%     final_images{i} = final_im;

%     % final_im = max_pooling(final_im, 5);   

%     % I_unbounded_cluster = Id .* repmat((Ig_final_mins == i), [1, 1, 3]);

%     % % remove most common color
%     % common_rgb = median(median(final_im, 1));

%     % remove_back = (sum(((final_im - repmat(common_rgb, [size(final_im, 1), size(final_im, 2), 1])) .^ 2), 3) > 0.01);
%     % final_im_remove = final_im .* repmat(remove_back, [1, 1, 3]);

%     % im_color_avg(i, :) = reshape(sum(sum(final_im_remove, 1)) ./ sum(sum(final_im_remove != 0, 1)), 1, 3); 

%     colormap(gray)
%     imagesc(final_im)

%     % s = seg_image(final_im, 0);

%     % final_images(i) = s;

%     % edges = [0:255];
%     % final_im_vec = reshape(final_im, 1, size(final_im, 1) * size(final_im, 2));
%     % hist_im_final = histc(final_im_vec, edges);
%     % figure(30 + i)
%     % plot(hist_im_final);
% end

% % convert image color average to bytes
% im_color_avg = im_color_avg .* 255;
