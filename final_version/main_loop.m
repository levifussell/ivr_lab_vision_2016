% the file to run to begin interactive with the interface and train/load
% models

% get training data from file
I_collection = {};
I_collection{1} = imread('simpler/02.jpg');
I_collection{2} = imread('simpler/03.jpg');
I_collection{3} = imread('simpler/04.jpg');
I_collection{4} = imread('simpler/05.jpg');
I_collection{5} = imread('simpler/06.jpg');
I_collection{6} = imread('simpler/07.jpg');
I_collection{7} = imread('simpler/08.jpg');
I_collection{8} = imread('simpler/09.jpg');
% I_collection{9} = imread('simpler/10.jpg');

I_training = {};
I_training{1} = imread('simpler/training/02.jpg');
I_training{2} = imread('simpler/training/03.jpg');
I_training{3} = imread('simpler/training/04.jpg');
I_training{4} = imread('simpler/training/05.jpg');
I_training{5} = imread('simpler/training/06.jpg');
I_training{6} = imread('simpler/training/07.jpg');
I_training{7} = imread('simpler/training/08.jpg');
I_training{8} = imread('simpler/training/09.jpg');
% I_training{9} = imread('simpler/training/10.jpg');

% interface begins here
lacm = input('what action? n= new model, s= segment a preloaded image, l= load model', 's');

if lacm == 's'
    % segment a preloaded image: I_collection{1}

    [final_images, class_images, seg_boxes] = image_segmentation(I_collection{1}, I_training{1}, 6, 2, true);

    for i=1:size(final_images, 2)
        figure(20 + i)
        imagesc(final_images{i})
        input('process image?');

        [feature_vec, feature_image, full_image_chunk] = get_object_feature_vector(final_images{i}, final_images{i}, i, true);
    end

    input('created segmented images. continue?');


elseif lacm == 'n'
    % build a new model

    % series of inputs from user
    ss = input('show image segments? Y/N\n\n   ', 's');
    if ss == 'y' || ss == 'Y'
        show_segments = true;
    else
        show_segments = false;
    end

    sfvs = input('show feature vector space? Y/N\n\n   ', 's');
    if sfvs == 'y' || sfvs == 'Y'
        show_vec = true;
    else
        show_vec = false;
    end

    model_name = input('type name of model: \n\n   ', 's');

    input('...click enter to begin building the model...');

    % train the model
    [nb_model, model_train_vecs, confusion_m, m_accuracy] = train_new_model(I_collection, I_training, show_segments, show_vec);

    % save the model file locally
    file_name = strcat([model_name, '.csv']);
    file_data = model_train_vecs;
    delim = ',';

    dlmwrite(file_name, file_data, delim);

elseif lacm == 'l'

    % load a current model
    old_model_file = input('type the filename of your model: \n\n   ', 's');
    old_model_file = strcat([old_model_file, '.csv']);

    delim = ',';
    file_data = dlmread(old_model_file, delim);

    input('loaded successfully. Hit enter to format the model...\n\n   ');
    
    % build the model from the training data (we can do this because models
    % are so small the user won't notice it being rebuilt)
    nb_model = fitNaiveBayes(file_data(:, 1:(size(file_data, 2) - 1)), file_data(:, size(file_data, 2)));
    
    feed = 'c';
    
    while feed == 'C' || feed == 'c'
        
        im_file = input('type image file to classify:\n\n   ', 's');
        
        pred_im = imread(im_file);
        
        % segment the objects from the image
        [final_images, class_images, seg_boxes] = image_segmentation(pred_im, pred_im, 6, 2, true);

        obj_vectors = [];
        obj_images = {};
        
        % itterate over each segmented object
        for i=1:size(final_images, 2)
            
            figure(20 + i)
            imagesc(final_images{i})
            input('process image?');
            
            % get the feature vector for this object
            [obj_vectors(size(obj_vectors, 1) + 1, :), feature_image, obj_images{size(obj_images, 2) + 1}] = get_object_feature_vector(final_images{i}, final_images{i}, i * 101, true);
%             figure()
%             imagesc(feature_image)
        end
        
        pred_class = nb_model.predict(obj_vectors);
        
        pred_im_with_outcome = pred_im;
        
        for i=1:size(final_images, 2)
        
%             if isnan(pred_class(i, 1)) == false && pred_class(i, 1) > 0
                
                b_size = 2;
                pred_im_with_outcome(seg_boxes{i}(1):seg_boxes{i}(2), seg_boxes{i}(3), 1) = 255;
                pred_im_with_outcome(seg_boxes{i}(1):seg_boxes{i}(2), seg_boxes{i}(4), 1) = 255;
                pred_im_with_outcome(seg_boxes{i}(1), seg_boxes{i}(3):seg_boxes{i}(4), 1) = 255;
                pred_im_with_outcome(seg_boxes{i}(2), seg_boxes{i}(3):seg_boxes{i}(4), 1) = 255;
                
%             end
            
        end
        
        figure()
        imagesc(pred_im_with_outcome)
        
        for i=1:size(final_images, 2)
        
%             if isnan(pred_class(i, 1)) == false && pred_class(i, 1) > 0
            
                text(seg_boxes{i}(3), seg_boxes{i}(1), num2class_type(pred_class(i, 1)));
                
%             end
        end
        
    end
    
end


