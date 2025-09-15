# AMS595_Project1

## Overview
This repository contains MATLAB code for estimating π using the **Monte Carlo hit-or-miss method**.  
Random points are generated in the unit square `[0,1] × [0,1]`.  
The proportion of points that fall inside the quarter circle estimates π/4, giving:

\[
\hat{\pi} = 4 \cdot \frac{\#\text{points inside}}{\#\text{total points}}
\]

The project is divided into three tasks:

1. **Task 1**: For loop with fixed sample size; plots error vs N, runtime vs N, and accuracy vs cost.  
2. **Task 2**: While loop that stops once the confidence interval half-width meets a tolerance for `k` significant figures (does not rely on the true π).  
3. **Task 3**: Function with dynamic scatter visualization. Points inside the circle are colored differently, and the final π estimate is displayed both in the command window and on the plot.

---

## Repository Contents
