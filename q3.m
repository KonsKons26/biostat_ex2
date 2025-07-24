% The measurements of two characteristics x and y measured in pairs during a medical
% study on nine patients are recorded in the following table
%
% X | 4  7  1  5  8   5   2  4  3
% Y | 80 92 52 76 106 100 69 71 65

% Load the data
X = [4; 7; 1; 5; 8; 5; 2; 4; 3];
Y = [80; 92; 52; 76; 106; 100; 69; 71; 65];

% First check that theyx and y follow normal distributions
% Lillefors test
disp("Lillefors normality tests");

[h, p] = lillietest(X, 0.05);
disp("X");
disp(["result: ", h, "p-value", p]);

[h, p] = lillietest(Y, 0.05);
disp("Y");
disp(["result: ", h, "p-value", p]);

figure;
hold on;
normplot(X);
title("Q-Q plot for the X variable");
hold off;

figure;
hold on;
normplot(Y);
title("Q-Q plot for the Y variable");
hold off;


%%%%%
% a %
%%%%%
figure;
hold on;
scatter(X, Y, 75, "filled");
title("Scatter Plot of Measurements");
xlabel("X");
ylabel("Y");
xlim([min(X) - 0.05*range(X), max(X) + 0.05*range(X)]);
ylim([min(Y) - 0.05*range(Y), max(Y) + 0.05*range(Y)]);
hold off;


%%%%%
% b %
%%%%%
% They seem pisitively correlated


%%%%%
% c %
%%%%%
% Correlation coefficient
[rho, pval] = corr(X, Y);
disp(["Correlation coefficient: ", rho]);


%%%%%
% d %
%%%%%
% Can we reject the hypothesis that the correlation coefficient for the population
% is zero at the 5% significance level
disp(["p-value: ", pval]);
alpha = 0.05;
if pval <= alpha
    disp("Null hypothesis rejected. X and Y are correlated");
else
    disp("Null hypothesis not rejected. X and Y are not correlated");
end