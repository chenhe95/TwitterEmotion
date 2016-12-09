function [Y_hat] = predict_labels(word_counts, cnn_feat, prob_feat, color_feat, raw_imgs, raw_tweets)
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
load ./models_svm_pca.mat

%% preprocess
word_counts_processed = full(double(word_counts ~= 0));

word_counts_processed(:, preprocess) = [];
word_counts_processed(:, c_removed) = [];

wc_score_test = word_counts_processed * saved_pc;

%% Predict
wc_out = predict(wc_model, wc_score_test);
Y_hat = full(wc_out);

end
