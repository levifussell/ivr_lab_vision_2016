function [] = draw_bumpmap(m_image, i)

    x_v = [1:size(m_image, 2)];
    y_v = [1:size(m_image, 1)];
    [yy, xx] = meshgrid(x_v, y_v);
    figure(i)
    mesh(xx, yy, m_image)
    
end