ks = [2 3 4];
rows = [];

for k = ks
    [pi_hat, n_total, iter_hist] = task2_while_precision(k);
    halfwidth_final = iter_hist(end,3);  
    rows = [rows; k, n_total, pi_hat, halfwidth_final]; 
end

T = array2table(rows, 'VariableNames', ...
    {'k','n_samples','pi_hat','halfwidth_pi'});

disp('=== Task 2 Summary ===');
disp(T);