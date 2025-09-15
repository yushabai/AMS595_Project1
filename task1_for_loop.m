function task1_for_loop()
   
    rng(42);   % Fix the random seed for reproducibility

    % Define a range of sample sizes (N values)
    N_list = round(logspace(2, 6, 10));   % From 1e2 to 1e6, 10 points
    pi_hat = zeros(size(N_list));         % Store π estimates
    err    = zeros(size(N_list));         % Store absolute errors
    t_sec  = zeros(size(N_list));         % Store runtimes

    for i = 1:numel(N_list)
        N = N_list(i);
        tic;  % Start timer

        % Generate N random points uniformly in [0,1] × [0,1]
        x = rand(N,1);
        y = rand(N,1);

        % Check whether points are inside the quarter circle
        inside = (x.^2 + y.^2) <= 1;

        % Estimate π using the ratio of points inside
        p_hat = mean(inside);
        pi_hat(i) = 4 * p_hat;

        % Record elapsed time
        t_sec(i) = toc;

        % Compute error with respect to the true π (allowed in Task 1)
        err(i) = abs(pi_hat(i) - pi);
    end

    % --- Plot 1: Error vs N ---
    figure;
    loglog(N_list, err+eps, 'o-');
    xlabel('N (sample size)'); ylabel('Error |π̂ - π|');
    title('Task 1: Error vs Sample Size');
    grid on;

    % --- Plot 2: Runtime vs N ---
    figure;
    loglog(N_list, t_sec, 'o-');
    xlabel('N (sample size)'); ylabel('Runtime (s)');
    title('Task 1: Runtime vs Sample Size');
    grid on;

    % --- Plot 3: Accuracy vs Cost (Error vs Time) ---
    figure;
    loglog(t_sec, err+eps, 'o-');
    xlabel('Runtime (s)'); ylabel('Error |π̂ - π|');
    title('Task 1: Accuracy vs Computational Cost');
    grid on;
end
