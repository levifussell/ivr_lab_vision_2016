function [box_final, box_left, box_right, box_top, box_bottom] = minimum_bounding_box(m_data)
% this function will attempt to find a minimum-bounding box of a binary
% image (or assuming that any pixel with 0 value is not the object to be
% bounded). This is not the most state-of-the-art method, but it does the
% trick effectively.

    testData = m_data;

    % find the centre of the non-empty area of pixels
    [v_y, v_x] = find(testData > 0);
    v_centre = [(sum(v_x, 1) ./ size(v_x, 1)), (sum(v_y, 1) ./ size(v_y, 1))];

    % set the data gained values to big numbers
    box_data = -100;
    data_gain = 100;
    box_offset = 5;

    % loop and expand the box until no data is gained
    while(data_gain > 0)

        % expand the box starting with a left and right expansion
        box_left = round(max(1, (v_centre(2) - box_offset)));
        box_right = round(min(size(testData, 1), (v_centre(2) + box_offset)));
        box_1 = testData(box_left:box_right, :);

        % calculate the amount of new data gained by expanding the box (num
        % new non-empty pixels)
        data_box_1 = sum(sum(box_1, 1));
        data_gain = data_box_1 - box_data;
        
        % if no data gain, save box and end loop
        if(data_gain > 0)
            box_final = box_1;
        end

        % otherwise expand the box
        box_data = data_box_1;
        box_offset = box_offset + 1;

    end

    %---- REPEAT the same process as above, but now expand the box
    %vertically, keeping the same left and right positions of the box
    %----
    
    box_data = -100;
    data_gain = 100;
    box_offset = 5;

    while(data_gain > 0)

        box_top = round(max(1, (v_centre(1) - box_offset)));
        box_bottom = round(min(size(testData, 2), (v_centre(1) + box_offset)));
        box_1 = testData(box_left:box_right, box_top:box_bottom);

        data_box_1 = sum(sum(box_1, 1));
        data_gain = data_box_1 - box_data;
        
        if(data_gain > 0)
            box_final = box_1;
        end

        box_data = data_box_1;
        box_offset = box_offset + 1;

    end
end