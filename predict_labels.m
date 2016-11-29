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

n_examples = size(word_counts, 1);

%% Load models
load ./models.mat

%% preprocess
word_counts_processed = full(double(word_counts ~= 0));

% remove 0 cols
word_counts_processed(:, c_removed) = [];

%% Predict
wc_out = predict(wc_model, word_counts_processed);
%cnn_out = predict(cnn_model, cnn_feat);
%color_out = predict(color_model, color_feat);
%prob_out = predict(prob_model, prob_feat);

%total_acc = wc_acc + cnn_acc + color_acc + prob_acc;

%Y_hat = (wc_acc * wc_out + cnn_acc * cnn_out + ...
%    color_acc * color_out + prob_acc * prob_out) / total_acc; 
%Y_hat = double(Y_hat >= 0.5);

Y_hat = wc_out;

end
