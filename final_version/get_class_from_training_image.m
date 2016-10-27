function [class_num] = get_class_from_training_image(m_image)
% given a segmented object from a training image, identify the colour that
% corresponds to the classification of that image

    % colours to look for for each class type
    class_rgb = zeros(10, 1);
    class_rgb(1, 1) = hash_rgb([0, 222, 255]); %one pound
    class_rgb(2, 1) = hash_rgb([218, 2, 251]); %two pound
    class_rgb(3, 1) = hash_rgb([0, 255, 151]); %50p
    class_rgb(4, 1) = hash_rgb([255, 246, 0]); %20p
    class_rgb(5, 1) = hash_rgb([255, 138, 0]); %5p
    class_rgb(6, 1) = hash_rgb([30, 0, 254]); %washer small hole
    class_rgb(7, 1) = hash_rgb([254, 0, 0]); %washer large hole
    class_rgb(8, 1) = hash_rgb([0, 255, 49]); %angle bracket
    class_rgb(9, 1) = hash_rgb([132, 1, 255]); %AAA battery
    class_rgb(10, 1) = hash_rgb([180, 255, 0]); %nut
    
    %hash the colour values (to make it single-value comaprison
    hashed_im = hash_rgb(double(m_image));

    class_amounts = zeros(10, 1);
    % itterate through each colour and count the number of class colours in
    % the training image (the reason we do this is so that if an image is
    % badly segmented and contains extra class colours, we can pick the
    % colour that appears the most and still classify correctly)
    for i=1:10
        class_amounts(i, 1) = size(find(hashed_im == class_rgb(i, 1)), 1);
    end

    % if no class was found, the image was not segmented properly; set to
    % class -1 so we can ignore this case
    if sum(class_amounts, 1) == 0
        class_num = -1;
    else
        % otherwise return the class colour that appears most in the image
        [max_v, class_num] = max(class_amounts);
    end
end