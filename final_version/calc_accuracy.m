function [error_v] = calc_accuracy(model_output, expected_output)
% given the target output of the model and the expected output of the
% model, calculate the accuracy of the model

    num_correct = sum((model_output == expected_output), 1);
    error_v = num_correct / size(model_output, 1);

end