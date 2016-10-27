function [con_m] = confusion_matrix(model_value, expected_value, num_classes)
% given the output of the model and the expected output of the model (and
% number of epected classes), create a confusion matrix for analysing the
% correctness of the model

    con_m = zeros(num_classes, num_classes);

    for i=1:num_classes
        for j=1:num_classes

            con_m(i, j) = sum((model_value == i) .* (expected_value == j));
            
        end
    end

end