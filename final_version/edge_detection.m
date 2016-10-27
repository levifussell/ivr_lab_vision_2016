function [image_edge] = edge_detection(image_m, gauss_window)
% uses thresholds and convolution matrices to segment an image into the
% most significant buckets. This function does not make the image binary,
% but is a pre-processing step for doing so; instead it reduces the
% complexity of the image and helps for background removal

    edges = transpose(1:255);
%     edges = zeros(256, 1);
%     
%     for i = 1:256
%         edges(i) = i-1;
%     end

    [rows, columns] = size(image_m);
    Ig_vec = reshape(image_m, 1, rows * columns);

    size(Ig_vec)
    size(edges)
    I_hist = histcounts(Ig_vec, edges);
    
    % figure(2)
    % plot(I_hist);

    % hold on

    filter = gauss_window;
    filter = filter/sum(filter);
    % figure(3)
    % plot(filter)

    smooth_hist = conv(filter, I_hist);
    
    % figure(int64(rand() * 1000))
    % plot(smooth_hist)

    % hold on

    % find minimums between thresholds
    offset_error = 0;
    a = smooth_hist < ([10, smooth_hist(:, 1:(size(smooth_hist, 2) - 1))] - repmat(offset_error, 1, size(smooth_hist, 2)));
    b = smooth_hist < ([smooth_hist(:, 2:size(smooth_hist, 2)), 10] - repmat(offset_error, 1, size(smooth_hist, 2)));
    hist_maximums = a .* b .* smooth_hist;

%     hist_maximums -= 40000 .* (hist_maximums == 0);

    % plot(hist_maximums, '*', 'markersize', 10)


    % I_bw = (Ig < 150);
    % figure(2)
    % colormap(gray)
    % imagesc(I_bw)

    % create a set of thresholds
    I_thresholds = find(hist_maximums > 0);
    I_num_thresholds = size(I_thresholds, 2);
    threshold_rate = 255 ./ I_num_thresholds;
    Ig_cluster = zeros(size(image_m));

    for i=1:I_num_thresholds

        Ig_cluster = Ig_cluster + (image_m < I_thresholds(:, i)) .* threshold_rate;
    end

    image_edge = Ig_cluster;

    % figure(30)
    % colormap(gray)
    % imagesc(Ig_cluster)

end