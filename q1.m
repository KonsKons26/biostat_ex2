%%%%%%%%%%%%%%%%%%%%
% Loading the data %
%%%%%%%%%%%%%%%%%%%%
% Measurements from 40 individuals
% x1 -> FSIQ
% x2 -> VIQ
% x3 -> PIQ
% x4 -> Weight
% x5 -> Height
% x6 -> Brain size via MRI

x1 = [
    133; 140; 139; 133; 137; 99; 138; 92; 89; 133; 132; 141; 135; 140; 96; 83; 132;
    100; 101; 80; 83; 97; 135; 139; 91; 141; 85; 103; 77; 130; 133; 144; 03; 90; 83;
    133; 140; 88; 81; 89
];

x2 = [
    132; 150; 123; 129; 132; 90; 136; 90; 93; 114; 129; 150; 129; 120; 100; 71; 132;
    96; 112; 77; 83; 107; 129; 145; 86; 145; 90; 96; 83; 126; 126; 145; 96; 96; 90;
    129; 150; 86; 90; 91
];

x3 = [
    124; 124; 150; 128; 134; 110; 131; 98; 84; 147; 124; 128; 124; 147; 90; 96; 120;
    102; 84; 86; 86; 84; 134; 128; 102; 131; 84; 110; 72; 124; 132; 137; 110; 86; 81;
    128; 124; 94; 74; 89
];

x4 = [
    118; 127; 143; 172; 147; 146; 138; 175; 134; 172; 118; 151; 155; 155; 146; 135;
    127; 178; 136; 180; 175; 186; 122; 132; 114; 171; 140; 187; 106; 159; 127; 191;
    192; 181; 143; 153; 144; 139; 148; 179
];

x5 = [
    64.5; 72.5; 73.3; 68.8; 65.0; 69.0; 64.5; 66.0; 66.3; 68.8; 64.5; 70.0; 69.0;
    70.5; 66.0; 68.0; 68.5; 73.5; 66.3; 70.0; 75.1; 76.5; 62.0; 68.0; 63.0; 72.0;
    68.0; 77.0; 63.0; 66.5; 62.5; 67.0; 75.5; 69.0; 66.5; 66.5; 70.5; 64.5; 74.0;
    75.5
];

x6 = [
    816932; 1001121; 1038437; 965353; 951545; 928799; 991305; 854258; 904858; 955466;
    833868; 1079549; 924059; 856472; 878897; 865363; 852244; 945088; 808020; 889083;
    892420; 905940; 790619; 955003; 831772; 935494; 798612; 1062462; 793549; 866662;
    857782; 949589; 997925; 879987; 834344; 948066; 949395; 893983; 930016; 935863
];


X = [x1 x2 x3 x4 x5 x6];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First lets inspect our data %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find and display the mean and standard deviation of each variable
means = mean(X);
std_devs = std(X);
fprintf('The mean of each variable are:\n');
disp(means);
fprintf('The standard deviation of each variable are:\n');
disp(std_devs);

% Standardize the data
X = zscore(X);

% plot the combination of all initial variables in 2D, i.e.
% x1 vs x2, x1 vs x3, ..., x4 vs x6, x5 vs x6
% with their correlation coefficients
corrcoefs = corrcoef(X);
[~, axes] = plotmatrix(X);
title(['Combination of All Initial Variables in pairs and their correlation ', ... 
    'coefficients']);
for i = 1:6
    for j = 1:6
        if i == 6
            axes(i, j).XLabel.String = sprintf('x%d', j);
        end
        if j == 1
            axes(i, j).YLabel.String = sprintf('x%d', i);
        end
        if j ~= i
            ax = axes(i, j);
            xpos = min(ax.XLim) + 0.01 * range(ax.XLim);
            ypos = max(ax.YLim) * 0.9;
            text(ax, xpos, ypos, sprintf('%.2f', corrcoefs(i, j)), ...
            'HorizontalAlignment', 'left', ...
            'VerticalAlignment', 'top', ...
            'FontSize', 10, 'FontWeight', 'bold', 'Color', 'red');
        end
    end
end


%%%%%%%%%
% A. i. %
%%%%%%%%%
% Perform PCA to find the smallest number of principal components that explain at
% least 80% of the variability.

% Perform PCA
[coeff, score, latent, ~, explained] = pca(X);

% Find the smallest number of principal components that explain at least 80% of the
% variability
cumulative_explained = cumsum(explained);
num_components = find(cumulative_explained >= 80, 1);

% Display the results
fprintf(['The smallest number of principal components that explain at least ', ...
    '80%% of the variability is %d.\n'], num_components);

% Plot the cumulative explained variance with a line and dots
figure;
plot(cumulative_explained, 'LineWidth', 2);
hold on;
scatter(1:6, cumulative_explained, 'filled');
xlabel('Number of Principal Components');
ylabel('Cumulative Explained Variance (%)');
title('Cumulative Explained Variance by Number of Principal Components');
grid on;
hold off;


%%%%%%%%%%
% A. ii. %
%%%%%%%%%%
% Determine the coordinates of each principal component of question A. i. with
% respect to the initial variables.

fprintf(['The coordinates of each principal component with respect to the ', ...
    'initial variables are:\n']);
disp(coeff(:, 1:num_components));


%%%%%%%%%%%
% A. iii. %
%%%%%%%%%%%
% Determine the coordinates of the data set in the coordinates system defined by the
% principal components of question A. i.

fprintf(['The coordinates of the data set in the coordinates system defined ', ...
    'by the principal components are:\n']);
disp(score(:, 1:num_components));


%%%%%
% B %
%%%%%
% Produce the Y-index calculated using the values of the variables in the data set
% based on the relation:
% Y = 3*(x1 + x2 + x3) - 4*x4 + 5*x5 + 3*x6
% Then find the coefficients of the multiple linear regression model of the variable
% Y, taking as independent variables the principal components of question A. i.

Y = 3 * (X(:, 1) + X(:, 2) + X(:, 3)) - 4 * X(:, 4) + 5 * X(:, 5) + 3 * X(:, 6);

% Perform multiple linear regression
mdl = fitlm(score(:, 1:num_components), Y);

% Display the results
fprintf(['The coefficients of the multiple linear regression model of the ', ...
    'variable Y, taking as independent variables the principal components ', ...
    'are:\n']);
disp(mdl.Coefficients.Estimate);
