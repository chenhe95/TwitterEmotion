function [error] = cv_test_10f(word_counts, cnn_feat, prob_feat, color_feat, raw_imgs, raw_tweets)

n_examples = size(word_counts, 1);

% indices for 10f cross validation
cv_10f_indices = crossvalind('Kfold', n_examples, 10);



end
