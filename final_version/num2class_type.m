function [ class_name ] = num2class_type( class_num )

    if class_num == 1
        class_name = '1£';
    elseif class_num == 2
        class_name = '2£';
    elseif class_num == 3
        class_name = '50p';
    elseif class_num == 4
        class_name = '20p';
    elseif class_num == 5
        class_name = '5p';
    elseif class_num == 6
        class_name = 'wash. small';
    elseif class_num == 7
        class_name = 'wash. large';
    elseif class_num == 8
        class_name = 'angle';
    elseif class_num == 9
        class_name = 'battery';
    elseif class_num == 10
        class_name = 'nut';
    else
        class_name = 'unknown';
    end
        
end

