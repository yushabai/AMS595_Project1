function [pi_hat, n_total, iter_hist] = task2_while_precision(k, alpha, B)

    % ----- Defaults -----
    if nargin < 1 || isempty(k),     k = 3;       end
    if nargin < 2 || isempty(alpha), alpha = 0.05;end
    if nargin < 3 || isempty(B),     B = 5000;    end

    % ----- Setup (no toolbox dependency) -----
    tol = 0.5 * 10^(1 - k);                  % Half-ULP for k sig figs
    z   = sqrt(2) * erfinv(2*(1 - alpha/2) - 1);  % Φ^{-1}(1-α/2)
    rng(42);                                  % reproducible runs for reports

    n_total   = 0;
    hit_total = 0;
    iter_hist = [];                            % [n, pi_hat, halfwidth_pi]

    % ----- While loop -----
    while true
        % Sample a new batch
        x = rand(B,1); y = rand(B,1);
        inside = (x.^2 + y.^2) <= 1;

        % Accumulate counts
        n_total   = n_total   + B;
        hit_total = hit_total + sum(inside);

        % Estimate π
        p_hat  = hit_total / n_total;
        pi_hat = 4 * p_hat;

        % Wald CI half-width for π
        se = sqrt(max(p_hat*(1 - p_hat), eps) / n_total);
        halfwidth_pi = 4 * z * se;

        % Record
        iter_hist = [iter_hist; n_total, pi_hat, halfwidth_pi]; %#ok<AGROW>

        % Stop when within tolerance (no true π used)
        if halfwidth_pi <= tol
            break;
        end
    end

    % Log summary
    fprintf('[Task2] k=%d, alpha=%.2f, B=%d => n=%d, pi_hat=%.6f, halfwidth_pi=%.4g\n', ...
            k, alpha, B, n_total, pi_hat, halfwidth_pi);
end
