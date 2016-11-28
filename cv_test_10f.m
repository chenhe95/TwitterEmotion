function [error] = cv_test_10f(word_counts, cnn_feat, prob_feat, color_feat, raw_imgs, raw_tweets, labels)

n_examples = size(word_counts, 1);

% indices for 10f cross validation
K = 10;
errors = zeros(K, 1);
cv_10f_indices = crossvalind('Kfold', n_examples, K);
for i = 1:K
    indices_i = find(cv_10f_indices ~= i);
    predictions = predict_labels(word_counts(indices_i, :), cnn_feat(indices_i, :), prob_feat(indices_i, :), color_feat(indices_i, :), raw_imgs(indices_i, :), raw_tweets(indices_i, :));
    errors(i) = sum(predictions ~= labels);
end

error = mean(errors);

end
