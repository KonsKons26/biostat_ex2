% A company of medical equipment sells three types of analyzers and is interested to
% find out if the type of analyzer sold has an effect on whether a sale is made, as
% well as what time of day the sale is made. The following table records the sales in
% hundreds of Euros of 36 company’s representatives divided by the type of analyzer
% and by the time of day

%%%%%%%%%%%%%%%%%
% Load the data %
%%%%%%%%%%%%%%%%%

%           | type1 type2 type3
%           | =================
%  morgning |  6.3   6.1   3.2
%           |  7.1   3.9   4.2
%           |  5.5   4.3   4.8
%           |  5.9   4.8   5.3
%           | -----------------
%    noon   |  5.3   5.3   5.1
%           |  6.6   3.9   3.7
%           |  6.8   4.2   4.8
%           |  7.2   4.1   4.7
%           | -----------------
% afternoon |  8.2   4.3   4.9
%           |  9.1   5.8   5.5
%           |  6.4   4.1   4.8
%           |  7.5   5.2   5.7

types_names = ["type1", "type2", "type3"];
times_names = ["morning", "noon", "afternoon"];

type1 = [6.3; 7.1; 5.5; 5.9; 5.3; 6.6; 6.8; 7.2; 8.2; 9.1; 6.4; 7.5];

tyep2 = [6.1; 3.9; 4.3; 4.8; 5.3; 3.9; 4.2; 4.1; 4.3; 5.8; 4.1; 5.2];

type3 = [3.2; 4.2; 4.8; 5.3; 5.1; 3.7; 4.8; 4.7; 4.9; 5.5; 4.8; 5.7];

morning = [6.3; 7.1; 5.5; 5.9; 6.1; 3.9; 4.3; 4.8; 3.2; 4.2; 4.8; 5.3];

noon = [5.3; 6.6; 6.8; 7.2; 5.3; 3.9; 4.2; 4.1; 5.1; 3.7; 4.8; 4.7];

afternoon = [8.2; 9.1; 6.4; 7.5; 4.3; 5.8; 4.1; 5.2; 4.9; 5.5; 4.8; 5.7];

types = [type1, tyep2, type3];

times = [morning, noon, afternoon];

%%%%%%%%%%%%%%%%%%%%%%%%%
% assumptions for ANOVA %
%%%%%%%%%%%%%%%%%%%%%%%%%

% For the types array %

% independence
% assumed independent due to the nature of the problem

% normality check
% Lilliefors normality test
disp("Lilliefors normality test");
for i = 1:3
    [h, p, ksstat, cv] = lillietest(types(:, i), 'alpha', 0.05);
    disp([types_names(i), "result", h, "p-value", p]);
end

% Q-Q plot
for i = 1:3
    figure;
    hold on;
    normplot(types(:, i));
    title(sprintf("Normality plot for analyzer %s", types_names(i)));
    hold off;
end

% equality of variances 
disp("Vartest");
[p, stats] = vartestn(types);
p
stats


% For the times array %

% independence
% assumed independent due to the nature of the problem

% normality check
% Lilliefors normality test
disp("Lilliefors normality test");
for i = 1:3
    [h, p, ksstat, cv] = lillietest(types(:, i), 'alpha', 0.05);
    disp([times_names(i), "result", h, "p-value", p]);
end

% Q-Q plot
for i = 1:3
    figure;
    hold on;
    normplot(types(:, i));
    title(sprintf("Normality plot for time of day %s", times_names(i)));
    hold off;
end

% equality of variances 
disp("Vartest");
[p, stats] = vartestn(times);
p
stats


%%%%%
% a %
%%%%%
% At a significance level or 5%, test the hypothesis that the type of analyzer does
% not affect sales

% one-way ANOVA
[p, ~, stats] = anova1(types, types_names);
disp(["p-value", p]);
multcompare(stats);

%%%%%
% b %
%%%%%
% At a significance level or 5%, test the hypothesis that the time of day does not
% affect sales

% one-way ANOVA
[p, ~, stats] = anova1(times, times_names);
disp(["p-value", p]);
multcompare(stats);


%%%%%
% c %
%%%%%
% At a significance level or 5%, test the hypothesis that there is no interaction
% between the type of analyzers sold and the time of day

% independence
% assumed independent due to the nature of the problem

% normality check
% tested in questions a and b

% equality of variances
% testes in questions a and b

% two-way ANOVA
% we can use either the types array or the times array
% we have 4 replicates in each cell
[p, ~, stats] = anova2(types, 4, "on");
disp(["p-value", p]);
multcompare(stats);