load('train_set/words_train.mat');
load('train_set/train_cnn_feat.mat');
load('train_set/train_color.mat');
load('train_set/train_img_prob.mat');

n_examples = size(X, 1);

% indices for 10f cross validation
K = 10;
n_blocks = 4;
errors = zeros(K, 1);
cv_10f_indices = crossvalind('Kfold', n_examples, K);

labels = Y;
word_counts_processed = full(double(X ~= 0));

% remove 0 cols
c_removed = find(~any(word_counts_processed, 1));
word_counts_processed(:, c_removed) = [];

% for i = 1:K
%     indices_train = find(cv_10f_indices ~= i);
%     indices_test = find(cv_10f_indices == i);
%     word_counts_train = word_counts_processed(indices_train, :);
%     word_counts_test = word_counts_processed(indices_test, :);
%     cnn_feat_train = train_cnn_feat(indices_train, :);
%     cnn_feat_test = train_cnn_feat(indices_test, :);
%     color_feat_train = train_color(indices_train, :);
%     color_feat_test = train_color(indices_test, :);
%     prob_feat_train = train_img_prob(indices_train, :);
%     prob_feat_test = train_img_prob(indices_test, :);
%     labels_train = labels(indices_train, :);
%     labels_test = labels(indices_test, :);
%     
%     wc_model = fitNaiveBayes(word_counts_train, labels_train, 'Distribution', 'mn');
%     wc_out = predict(wc_model, word_counts_test);
%     wc_acc = 1 / sum(labels_test ~= wc_out);
%     
% %     wc_model = fitcknn(word_counts_train, labels_train, 'NumNeighbors', 20);
% %     wc_out = predict(wc_model, word_counts_test);
% %     wc_acc = 1 / sum(labels_test ~= wc_out);
% 
% %     cnn_model = fitcknn(cnn_feat_train, labels_train, 'NumNeighbors', 5);
% %     cnn_out = predict(cnn_model, cnn_feat_test);
% %     cnn_acc = 1 / sum(labels_test ~= cnn_out);
% % 
% %     color_model = fitcknn(color_feat_train, labels_train,  'NumNeighbors', 5);
% %     color_out = predict(color_model, color_feat_test);
% %     color_acc = 1 / sum(labels_test ~= color_out);
% % 
% %     prob_model = fitcknn(prob_feat_train, labels_train, 'NumNeighbors', 5);
% %     prob_out = predict(prob_model, prob_feat_test);
% %     prob_acc = 1 / sum(labels_test ~= prob_out);
% 
% %     total_acc = wc_acc + cnn_acc + color_acc + prob_acc;
% % 
% %     Y_hat = (wc_acc * wc_out + cnn_acc * cnn_out + ...
% %         color_acc * color_out + prob_acc * prob_out) / total_acc; 
% %     Y_hat = double(Y_hat >= 0.5);
%     
%    % errors(i) = mean(Y_hat ~= labels_test);
%    errors(i) = mean(wc_out ~= labels_test);
% end
% 
% error = mean(errors);

wc_model = fitNaiveBayes(word_counts_processed, labels, 'Distribution', 'mn');

% Date included for record. predict() will look for models.mat
d = datetime;
%save(['models-' datestr(d) '.mat'], 'wc_model', 'cnn_model', 'prob_model', 'color_model', 'wc_acc', 'cnn_acc', 'color_acc', 'prob_acc', 'c_removed');
save(['models-' datestr(d) '.mat'], 'wc_model', 'c_removed');
