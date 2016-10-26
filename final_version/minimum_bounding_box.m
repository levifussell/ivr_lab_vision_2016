
function [box_final, box_left, box_right, box_top, box_bottom] = minimum_bounding_box(m_data)

    testData = m_data;

    [v_y, v_x] = find(testData > 0);

    v_centre = [(sum(v_x, 1) ./ size(v_x, 1)), (sum(v_y, 1) ./ size(v_y, 1))];

    box_data = -100;
    data_gain = 100;
    box_offset = 5;

    while(data_gain > 0)

        box_left = round(max(1, (v_centre(2) - box_offset)));
        box_right = round(min(size(testData, 1), (v_centre(2) + box_offset)));
        box_1 = testData(box_left:box_right, :);

        data_box_1 = sum(sum(box_1, 1));
        data_gain = data_box_1 - box_data;
        
        if(data_gain > 0)
            box_final = box_1;
        end

        box_data = data_box_1;
        box_offset = box_offset + 1;

    end

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