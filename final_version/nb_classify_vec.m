function [class_v] = nb_classify_vec(obj_vec, means, inv_cov, a_prioris)

    num_classes = size(means, 1);
    probs = zeros(num_classes, 1);

    for i=1:num_classes

        probs(i, 1) = ...
        multivariate_gauss(obj_vec, means(i, :), reshape(inv_cov(i, :, :), size(obj_vec, 2), size(obj_vec, 2)), a_prioris(i, 1)); %* a_prioris(i, 1);

        if isnan(probs(i, 1))
            probs(i, 1) = -1;
        end

    end
    probs
    [v, class_v] = max(probs);

end