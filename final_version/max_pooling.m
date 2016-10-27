function [M] = max_pooling(m, m_size)

    pool_r = floor(size(m, 1) / m_size);
    pool_c = floor(size(m, 2) / m_size);

    M = double(zeros(pool_r, pool_c));

    for r=1:pool_r
        for c=1:pool_c
            r_ind = (r - 1) .* m_size + 1;
            c_ind = (c - 1) .* m_size + 1;
            overM = zeros(size(m));
            overM(r_ind:(r_ind+m_size - 1), c_ind:(c_ind+m_size - 1)) = double(ones(m_size, m_size));
            pooled_out_m = overM .* double(m);
            M(r, c) = max(max(pooled_out_m));
        end
    end
end