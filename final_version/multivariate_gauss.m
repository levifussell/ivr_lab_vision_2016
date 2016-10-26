function [prob] = multivariate_gauss(query_vec, mean_v, inv_cov, a_priori)

    diffs = query_vec - mean_v;
    n = size(query_vec, 2);
    wgt = sqrt(det(inv_cov));
    dist = diffs * inv(inv_cov) * transpose(diffs);
    % prob = a_priori * (1 / (2 * pi)^(n/2)) * wgt * exp(-0.5 * dist);

    lnp = -(n/2) * log(2*pi) - 0.5 * log(det(inv_cov)) - 0.5 * (dist);

    prob = log(a_priori) + lnp;

end