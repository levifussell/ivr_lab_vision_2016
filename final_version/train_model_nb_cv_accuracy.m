function [ accuracy, accuracies ] = train_model_nb_cv_accuracy( cv_data )

    accuracies = zeros(size(cv_data, 2), 1);

    for i=1:size(cv_data, 2)
       
        test_data = cv_data{i};
        
        train_data = [];
        
        for j=1:size(cv_data, 2)
           
            if i ~= j
                s_data_train = size(train_data, 1);
                train_data((s_data_train + 1):(s_data_train + size(cv_data{j}, 1)), :) = cv_data{j};
            end
        end
        
        nb_model = fitNaiveBayes(train_data(:, 1:(size(train_data, 2) - 1)), train_data(:, size(train_data, 2)));
        pred_classes = nb_model.predict(test_data(:, 1:(size(test_data, 2) - 1)));
        accuracies(i, 1) = calc_accuracy(pred_classes, test_data(:, size(test_data, 2)));
        
    end
    
    accuracy = sum(accuracies, 1) / size(accuracies, 1);

end
