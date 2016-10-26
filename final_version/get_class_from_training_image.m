function [class_num] = get_class_from_training_image(m_image)

    % colours to look for for each class type
    class_rgb = zeros(10, 1);
    class_rgb(1, 1) = hash_rgb([0, 222, 255]);
    class_rgb(2, 1) = hash_rgb([218, 2, 251]);
    class_rgb(3, 1) = hash_rgb([0, 255, 151]);
    class_rgb(4, 1) = hash_rgb([255, 246, 0]);
    class_rgb(5, 1) = hash_rgb([255, 138, 0]);
    class_rgb(6, 1) = hash_rgb([30, 0, 254]);
    class_rgb(7, 1) = hash_rgb([254, 0, 0]);
    class_rgb(8, 1) = hash_rgb([0, 255, 49]);
    class_rgb(9, 1) = hash_rgb([132, 1, 255]);
    class_rgb(10, 1) = hash_rgb([180, 255, 0]);
    
    % m_image
    hashed_im = hash_rgb(double(m_image));

    class_amounts = zeros(10, 1);

    for i=1:10

        class_amounts(i, 1) = size(find(hashed_im == class_rgb(i, 1)), 1);

    end

    if sum(class_amounts, 1) == 0
        class_num = -1;
    else
        [max_v, class_num] = max(class_amounts);
    end

end