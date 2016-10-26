function [error_v] = error_analysis(model_output, expected_output)

    num_correct = sum((model_output == expected_output), 1);

    error_v = num_correct / size(model_output, 1);

end