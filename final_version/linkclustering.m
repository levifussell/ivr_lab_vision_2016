function [num_clusters, assigned_cl] = linkclustering(m_data)
% a simple form of clustering that involves clustering pixels in an image
% only if they are direct neighbours (touching, not corners). This
% clustering algorithm is quick because it only requires each pixel be
% processed once. Downsides are that it relies on effective preprocessing of
% the image

    testData = m_data;

    % create a new Java Queue object
    q = javaObject('java.util.LinkedList');

    % array for storing classification of pixels
    assigned_cl = zeros(size(testData));
    num_clusters = 1;

    % maximum allowed number of itterations before clustering fails
    itterations = 10000000;

    while itterations > 0

        % check if queue is empty
        if q.size() == 0

            % find a non-zero pixel
            [v_row, v_col] = find(testData > 0);
            v = [v_row, v_col];

            % if no non-zero pixels exist, the algorithm is done
            if size(v, 1) == 0
                return
            else
                % otherwise add the first non-zero pixel to the queue and
                % assign it a class
                a = v(1, :);
                assigned_cl(a(1), a(2)) = num_clusters;
                num_clusters = num_clusters + 1;
                q.add(a);
            end
        end

        % pop the top value from the queue
        n = q.remove();
        testData(n(1), n(2)) = 0;
        n_edge = zeros(1, 2, 4);
        % get the direct neighbours of the popped pixel (space complexity)
        n_edge(:, :, 1) = [n(1), n(2) - 1];
        n_edge(:, :, 2) = [n(1) - 1, n(2)];
        n_edge(:, :, 3) = [n(1), n(2) + 1];
        n_edge(:, :, 4) = [n(1) + 1, n(2)];

        % itterate through neighbours, do edge-case checks and add all
        % neighbours to the queue after assigning them the class of the
        % popped pixel
        for i=1:4
            n_01 = n_edge(:, :, i);
            if sum((n_01(1) <= 0) + (n_01(2) <= 0) + (n_01(1) > size(testData, 1)) + (n_01(2) > size(testData, 2))) == 0
                if(testData(n_01(1), n_01(2)) > 0)
                    assigned_cl(n_01(1), n_01(2)) = assigned_cl(n(1), n(2));
                    q.add(n_01);
                end
            end
        end

        % count down the max itterations
        itterations = itterations - 1;

    end

end