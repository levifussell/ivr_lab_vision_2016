function [image_processed, total_image_reduction] = apply_conv_pool_sequence(image_in, sequence)

    image_processed = image_in;

    total_image_reduction = 1;

    % for now the filter is pre-set as a gaussian blur
    filter = [1 4 7 4 1;
            4 16 36 16 4;
            7 26 41 26 7;
            4 16 26 16 4;
            1 4 7 4 1] ./ 273;

    % filter = [
    %         16 36 16;
    %         26 41 26;
    %         16 26 16;
    %         ] ./ 273;

    for i=1:size(sequence, 1)

        % apply convolution
        if(sequence(i, 1) == 0)
            image_processed = conv2(image_processed, filter);

        % apply max pooling
        elseif(sequence(i, 1) == 1)
            pool_v = sequence(i, 2);
            image_processed = max_pooling(image_processed, pool_v);
            total_image_reduction = total_image_reduction * pool_v;
        end

        figure(20)
        colormap(gray)
        imagesc(image_processed);
    end

end
