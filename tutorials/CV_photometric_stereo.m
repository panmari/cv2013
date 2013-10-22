% measured radiances
I = [.5; .1; .3];
% positions of lights, should not be linearly dependent!
S = [5 5 5
    4 8 4
    2 2 1];

n_tilde = inv(S)*I;
rho = norm(n_tilde, 2)
n = n_tilde/rho


% measured radiances, more than 3 measurements
I = [.5; .1; .3; .2];
% positions of lights, should not be linearly dependent!
S = [5 5 5
    4 8 4
    2 2 1
    4 8 1];

S_inv_pseudo = pinv(S);
n_tilde = S_inv_pseudo*I;
rho = norm(n_tilde, 2);
n = n_tilde/rho;