function [nb_model, model_train_vecs, con_m, accuracy ] = train_new_model(I_collection, I_training, show_segmentation_ims, show_vec_space)
%

    obj_vectors = [];

    obj_classes = [];

    if show_segmentation_ims
        obj_images = {};

        %TEMP
        for i=1:11
            obj_images{i} = {};
        end
    end
        
    % itterate over each image in the collection of images
    for j=1:size(I_collection, 2)

        % segment the objects from the image
        [final_images, class_images] = image_segmentation(I_collection{j}, I_training{j}, 6, 2);

        % itterate over each segmented object
        for i=1:size(final_images, 2)

            % get the class for this object
            class_type = get_class_from_training_image(class_images{i});
            obj_classes(size(obj_vectors, 1) + 1, 1) = class_type;

            % get the feature vector for this object
            [obj_vectors(size(obj_vectors, 1) + 1, :), feature_image] = get_object_feature_vector(final_images{i}, j * 101 + i);

            if show_segmentation_ims
                % TEMP
                if(class_type > 0)
                    obj_images{class_type}{size(obj_images{class_type}, 2) + 1} = feature_image;
                else
                    obj_images{11}{size(obj_images{11}, 2) + 1} = feature_image;
                end
            end

        end
    end

    % find feature vectors that were made incorrectly (error in segmentation)
    % and remove them
    indx_nan = find(sum(isnan(obj_vectors ), 2) > 0);
    obj_vectors(indx_nan,:) = [];
    obj_classes(indx_nan,:) = [];
    indx_neg = find(obj_classes < 0);
    obj_vectors(indx_neg,:) = [];
    obj_classes(indx_neg,:) = [];

    % create a data|class matrix for training
    data_m = [obj_vectors, obj_classes];

    % % divide data into train/test
    [data_train, data_test] = create_train_test_data(data_m, 10, 0.9);

    % train a Naive Bayes classifier on the data
    nb_model = fitNaiveBayes(data_train(:, 1:(size(data_train, 2) - 1)), data_train(:, size(data_train, 2)));

    % apply the NB model to the test set
    pred_classes = nb_model.predict(data_test(:, 1:(size(data_test, 2) - 1)));

    % do cross-validation on the modeling
    num_bins = 30;
    data_cv = create_cv_train_test_data(data_m, 10, num_bins);
    [accuracy, accuracies] = train_model_nb_cv_accuracy(data_cv);

    % accuracy = error_analysis(pred_classes, data_test(:, size(data_test, 2)));

    % create a confusion matrix of the ouput
    con_m = confusion_matrix(pred_classes, data_test(:, size(data_test, 2)), 10);

    model_train_vecs = data_train;
    
    if show_vec_space
        % display a feature vector space of first 3 features for analysis
        scatter3(obj_vectors(:, 1), obj_vectors(:, 2), obj_vectors(:, 3), 12, obj_classes);
        xlabel('circle comparison');
        ylabel('holes in object');
        set(get(gca, 'ZLabel'), 'String', 'colour hash');
    end
        
    if show_segmentation_ims
        for c=1:10
            for i=1:size(obj_images{c}, 2)
                figure(c * 20 + i)
                colormap(gray)
                imagesc(obj_images{c}{i})
            end
        end
    end
    
end

