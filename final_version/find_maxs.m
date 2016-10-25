function [maxs] = find_maxs(m_data)

    a_x = m_data >= ([ones(size(m_data, 1), 1) .* 1000, m_data(:, 1:(size(m_data, 2) - 1))]);
    b_x = m_data >= ([m_data(:, 2:size(m_data, 2)), ones(size(m_data, 1), 1) .* 1000]);
    a_y = m_data >= ([ones(1, size(m_data, 2)) .* 1000; m_data(1:(size(m_data, 1) - 1), :)]);
    b_y = m_data >= ([m_data(2:size(m_data, 1), :); ones(1, size(m_data, 2)) .* 1000]);
    maxs = a_x .* b_x .* a_y .* b_y .* m_data;

end