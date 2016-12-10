function [Y_hat] = predict_labels_knn(word_counts, cnn_feat, prob_feat, color_feat, raw_imgs, raw_tweets)
% Inputs:   word_counts     nx10000 word counts features
%           cnn_feat        nx4096 Penultimate layer of Convolutional
%                               Neural Network features
%           prob_feat       nx1365 Probabilities on 1000 objects and 365
%                               scene categories
%           color_feat      nx33 Color spectra of the images (33 dim)
%           raw_imgs        nx30000 raw images pixels
%           raw_tweets      nx1 cells containing all the raw tweets in text
% Outputs:  Y_hat           nx1 predicted labels (1 for joy, 0 for sad)

%% Load models
load ./models_knn.mat

keyboard
%% preprocess
word_counts = full(word_counts);
word_counts(:, c_removed) = [];

word_counts_processed = full(double(word_counts ~= 0));

% remove 0 cols
word_counts_processed(:, ~any(word_counts_processed, 1)) = [];

%% Predict
wc_out = predict(wc_model, word_counts_processed);

Y_hat = full(wc_out);

end