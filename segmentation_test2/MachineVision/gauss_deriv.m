function [u_x] = gauss_deriv(u)
    const = 1/((2 * pi)^(1/(size(u, 2))));
    u_x = const .* -abs(u) .* exp(-0.5 .* abs(u).^2);
end