function [num_clusters, assigned_cl] = linkclustering(m_data)

    testData = m_data;

    % assigned_classes = find(m_data != 0);
    % num_clusters = 2;

    q = javaObject('java.util.LinkedList');

    assigned_cl = zeros(size(testData));
    num_clusters = 1;

    itterations = 1000000;

    while itterations > 0

        if q.size() == 0

            [v_row, v_col] = find(testData > 0);
            v = [v_row, v_col];

            if size(v, 1) == 0
                return
            else
                a = v(1, :);
                assigned_cl(a(1), a(2)) = num_clusters;
                num_clusters = num_clusters + 1;
                q.add(a);
            end
        end

        n = q.remove();
        testData(n(1), n(2)) = 0;
        n_edge = zeros(1, 2, 4);
        n_edge(:, :, 1) = [n(1), n(2) - 1];
        n_edge(:, :, 2) = [n(1) - 1, n(2)];
        n_edge(:, :, 3) = [n(1), n(2) + 1];
        n_edge(:, :, 4) = [n(1) + 1, n(2)];

        for i=1:4
            n_01 = n_edge(:, :, i);
            if sum((n_01(1) <= 0) + (n_01(2) <= 0) + (n_01(1) > size(testData, 1)) + (n_01(2) > size(testData, 2))) == 0
                if(testData(n_01(1), n_01(2)) > 0)
                    assigned_cl(n_01(1), n_01(2)) = assigned_cl(n(1), n(2));
                    q.add(n_01);
                end
            end
        end

        itterations = itterations - 1;

    end

end