function [image_processed, total_image_reduction] = apply_conv_pool_sequence(image_in, sequence)
% this function is a quick setup for easy experimenting with multiple
% layers of max_pooling and Gaussian blurring. For now the Gaussian is a
% set filter; this has been fine during testing.

    image_processed = image_in;

    % record the amount the image has been reduced by (via max_pooling)
    total_image_reduction = 1;

    % for now the filter is pre-set as a gaussian blur
    filter = [1 4 7 4 1;
            4 16 36 16 4;
            7 26 41 26 7;
            4 16 26 16 4;
            1 4 7 4 1] ./ 273;

    % itterate through the layer filters
    for i=1:size(sequence, 1)

        % apply convolution
        if(sequence(i, 1) == 0)
            image_processed = conv2(image_processed, filter);

        % apply max pooling
        elseif(sequence(i, 1) == 1)
            pool_v = sequence(i, 2);
            image_processed = max_pooling(image_processed, pool_v);
            % update the total image reduction from max-pooling
            total_image_reduction = total_image_reduction * pool_v;
        end
    end

end
