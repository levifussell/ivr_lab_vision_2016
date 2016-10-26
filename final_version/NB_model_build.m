function [means, inv_cov, a_priori] = NB_model_build(obj_vecs, obj_classes, num_classes)

    for i = 1:num_classes

        class_indx = find(obj_classes == i);
        class_vecs = obj_vecs(class_indx, :);
        means(i, :) = mean(class_vecs, 1);
        diffs = class_vecs - (ones(size(class_vecs, 1), 1) * means(i, :));
        inv_cov(i, :, :) = transpose(diffs) * diffs / (size(class_vecs, 1) - 1);
        a_priori(i, 1) = size(class_vecs, 1) / size(obj_classes, 1);
    end

end