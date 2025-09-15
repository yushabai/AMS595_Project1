function pi_hat = task3_function(k, alpha, B, plot_cap, save_path)

    % ----- Defaults -----
    if nargin < 1 || isempty(k),        k = 3;       end
    if nargin < 2 || isempty(alpha),    alpha = 0.05;end
    if nargin < 3 || isempty(B),        B = 5000;    end
    if nargin < 4 || isempty(plot_cap), plot_cap = 2e5; end

    % ----- 1) Run the core computation (Task 2) -----
    [pi_hat, n_total, iter_hist] = task2_while_precision(k, alpha, B);

    % iter_hist columns: [n_total, pi_hat, halfwidth_pi] per iteration
    % We will use iter_hist to "replay" the convergence on a dynamic scatter.

    % ----- 2) Prepare the figure/UI -----
    fig = figure('Name','Task 3 Monte Carlo \pi (dynamic scatter)');
    clf(fig); ax = axes(fig); hold(ax,'on'); axis(ax,[0 1 0 1]); axis(ax,'square');
    box(ax,'on'); grid(ax,'on');
    title(ax, sprintf('Monte Carlo \\pi  (target: %d significant figures)', k));
    xlabel(ax, 'x'); ylabel(ax, 'y');

    % Quarter-circle boundary
    t = linspace(0, pi/2, 200);
    plot(ax, cos(t), sin(t), 'k-', 'LineWidth', 1.2);

    % Status text box
    txtH = text(ax, 0.02, 0.95, '', 'Units','normalized');

    % Buffers for plotting (limit to keep it responsive)
    X_in = []; Y_in = [];
    X_out = []; Y_out = [];
    plotted = 0;

    % ----- 3) Replay loop: generate display-only batches and update UI -----
    % Note: These drawn points are for visualization only (they are not the
    % actual samples used in Task 2). The statistics come from iter_hist.
    for i = 1:size(iter_hist,1)
        if plotted >= plot_cap
            % UI still updates text with true stats, even if we stop adding points.
            stats_pi   = iter_hist(i,2);
            stats_hwpi = iter_hist(i,3);
            pi_str = sprintf('%.*g', k, stats_pi);
            set(txtH, 'String', sprintf('\\pi \\approx %s\nn = %d\nCI half-width = %.3g', ...
                                        pi_str, iter_hist(i,1), stats_hwpi));
            drawnow limitrate;
            continue;
        end

        % Number of points to plot in this "frame"
        to_draw = min(B, plot_cap - plotted);
        x = rand(to_draw,1); y = rand(to_draw,1);
        inside = (x.^2 + y.^2) <= 1;

        X_in  = [X_in;  x(inside)];  Y_in  = [Y_in;  y(inside)];
        X_out = [X_out; x(~inside)]; Y_out = [Y_out; y(~inside)];
        plotted = plotted + to_draw;

        % Draw/update scatter
        if ~isempty(X_in),  scatter(ax, X_in,  Y_in,  6, 'filled'); end
        if ~isempty(X_out), scatter(ax, X_out, Y_out, 6);           end

        % Update status text using the TRUE stats from iter_hist
        stats_pi   = iter_hist(i,2);
        stats_hwpi = iter_hist(i,3);
        pi_str = sprintf('%.*g', k, stats_pi);
        set(txtH, 'String', sprintf('\\pi \\approx %s\nn = %d\nCI half-width = %.3g', ...
                                    pi_str, iter_hist(i,1), stats_hwpi));

        drawnow limitrate;
    end

    % ----- 4) Stamp final result on the plot -----
    final_pi_str = sprintf('%.*g', k, pi_hat);
    text(ax, 0.02, 0.85, sprintf('FINAL: \\pi \\approx %s', final_pi_str), ...
         'Units','normalized', 'FontWeight','bold');

    % Also print to the console
    fprintf('[Task3] DONE: k=%d, alpha=%.2f, B=%d => n=%d, pi_hat=%.6f\n', ...
            k, alpha, B, n_total, pi_hat);

    % ----- 5) Save figure if requested -----
    if nargin >= 5 && ~isempty(save_path)
        try
            [folder,~,~] = fileparts(save_path);
            if ~isempty(folder) && ~exist(folder,'dir'), mkdir(folder); end
            saveas(fig, save_path);
            fprintf('Saved figure to: %s\n', save_path);
        catch ME
            warning('Failed to save figure: %s', ME.message);
        end
    end
end
