function [image_scaled] = scale_image(m_image, m_image_target, scale_v)

    image_expand_tiled = kron(m_image, ones(scale_v));
    
    loss_of_pixels = size(image_expand_tiled) - size(m_image_target);
    border_loss = ceil(abs(loss_of_pixels / 2));
    image_scaled = image_expand_tiled(border_loss(1):(size(image_expand_tiled, 1) - border_loss(1) - 1), 
                                        border_loss(2):(size(image_expand_tiled, 2) - border_loss(2) - 1));

end