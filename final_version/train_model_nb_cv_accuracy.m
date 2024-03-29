function [ accuracy, accuracies ] = train_model_nb_cv_accuracy( cv_data )
% using a set of cross-validation bins, his function will perform x (num
% bins) model trainings using each bin as a test set. At the end it will
% report the average of the accuracies of the classifiers.

    accuracies = zeros(size(cv_data, 2), 1);

    % itterate through each bin
    for i=1:size(cv_data, 2)
       
        % set the current bin as the test set
        test_data = cv_data{i};
        
        % compile a training set from the rest of the bins
        train_data = [];
        for j=1:size(cv_data, 2)
           
            if i ~= j
                s_data_train = size(train_data, 1);
                train_data((s_data_train + 1):(s_data_train + size(cv_data{j}, 1)), :) = cv_data{j};           
            end
        end
        
        % fit a model to the training and test set
        nb_model = fitNaiveBayes(train_data(:, 1:(size(train_data, 2) - 1)), train_data(:, size(train_data, 2)));
        pred_classes = nb_model.predict(test_data(:, 1:(size(test_data, 2) - 1)));
        % calculate the accuracy
        accuracies(i, 1) = calc_accuracy(pred_classes, test_data(:, size(test_data, 2)));
        
    end
    
    % get the average accuracy of the different models
    accuracy = sum(accuracies, 1) / size(accuracies, 1);

end

