% The following table provides the experience and monthly salaries of (randomly
% selected) nurses in a country X
%
%   experience  | Monthly salary
%   (years)     | (hundreds of Euros)
%   ---------------------------------
%   18          | 57
%   10          | 50
%   4           | 25
%   5           | 28
%   6           | 33
%   3           | 19
%   16          | 50
%   8           | 45
%   14          | 52

% a. Provide the scatter plot of the data using experience as an independent
% variable andmonthly salary as a dependent variable.
% 
% b. On the above graph, plot the least squares line that fits the data points.
% 
% c. What percentage of the variability of the dependent variable is explained by
% the above line?
% 
% d. Provide the interpretation of the coefficients of the above line
% 
% e. What is the forecasted monthly salary of a nurse when her experience is equal
% to:
%   i. 9 years
%   ii. 15 years
%   iii. 21 years
% 
% f. Can we reject the hypothesis that there is no linear relationship between the
% monthl ysalary and the experience for nurses in country X, at a 5% significance
% level?
% 
% Hint: Provide analytically the conditions to apply the linear regression and check
% their validity.

%%%%%%%%
% DATA %
%%%%%%%%
years = [18; 10; 4; 5; 6; 3; 16; 8; 14];
salary = [57; 50; 25; 28; 33; 19; 50; 45; 52];


%%%%%
% a %
%%%%%
figure;
hold on;
scatter(years, salary, 75, "filled");
title("Experience vs Salary");
xlabel("Experience (years)");
ylabel("Montlhy salary (hundreds of Euros)");
xlim([min(years) - 0.05*range(years), max(years) + 0.05*range(years)]);
ylim([min(salary) - 0.05*range(salary), max(salary) + 0.05*range(salary)]);
hold off;


%%%%%
% b %
%%%%%
x = [ones(size(years)) years];
C = regress(salary, x);

figure;
hold on;
scatter(years, salary, 75, "filled");
title("Experience vs Salary");
xlabel("Experience (years)");
ylabel("Montlhy salary (hundreds of Euros)");
xlim([min(years) - 0.05*range(years), max(years) + 0.05*range(years)]);
ylim([min(salary) - 0.05*range(salary), max(salary) + 0.05*range(salary)]);
x_fit = linspace(min(years), max(years), 100);
y_fit = C(1) + C(2) * x_fit;
plot(x_fit, y_fit, 'r-', 'LineWidth', 2);
legend('Data points', 'Least squares regression line');
hold off;

% Assumptions %
% Residual analysis:
stats = regstats(salary, years, 'linear', {'standres','studres' });

% 1. Normality test
[h, p] = lillietest(stats.standres, 0.05);
disp("Standardized residuals:");
disp(["result: ", h, "p-value", p]);
figure;
hold on;
normplot(stats.standres);
title("Q-Q plot for the standardized residuals");
hold off;

% 2. Constant variance test
yest = x * C;
figure;
hold on;
title("Constant variance test");
xlabel("Y_{est}");
ylabel("Studentized residuals");
scatter(yest, stats.studres);
ylim([-10, 10]);
hold off;

% 3. Linearity test
% Shown from the above question, seems linear

% 4. Independency test
% By definition independent 


%%%%%
% c %
%%%%%
% Calculate the R-squared value
R = corr(years, salary);
Rsq = R^2;
Rsq_perc = Rsq * 100;
fprintf('Percentage of variability explained: %.2f%%\n', Rsq_perc);


%%%%%
% d %
%%%%%
disp(["C(1)", C(1)]);
disp(["C(2)", C(2)]);

%%%%%
% e %
%%%%%
%   i. 9 years
forecast_9 = [1 9] * C;
disp("Expected salary in hundreds of Euros for a nurse with 9 years experience:")
disp(forecast_9);

%   ii. 15 years
forecast_15 = [1 15] * C;
disp("Expected salary in hundreds of Euros for a nurse with 15 years experience:")
disp(forecast_15);

%   iii. 21 years
% NOTE: 21 is not in our range of years, should not accept the answer
forecast_21 = [1 21] * C;
disp("Expected salary in hundreds of Euros for a nurse with 21 years experience:")
disp(forecast_21);


%%%%%
% e %
%%%%%
% ANOVA with three EQUIVALENT null hypotheses:
% - There is no linear relationship in the population between the
% dependent and the independent variable.
% - The regression coefficient b in the population is equal to zero.
% - The R^2 for the population is equal to zero.
% 
% If the p-value is less than the significance level,
% the null hypothesis is rejected.
[p, ~, stats] = anova1(salary, years);
alpha = 0.05;
if p <= alpha
    fprintf("Null hypothesis rejected, there is linear relationship, (p-value = %d)", p);
else
    fprintf("Null hypothesis not rejected, there is no alinear relationship, (p-value = %d)", p);
end