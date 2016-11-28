load('train_set/words_train.mat');
load('train_set/train_cnn_feat.mat');
load('train_set/train_color.mat');
load('train_set/train_img_prob.mat');

% will do preprocessing later
labels = Y;
word_counts_processed = full(X);

wc_model = fitcsvm(word_counts_processed, labels);
wc_out = predict(wc_model, word_counts_processed);
wc_acc = 1 / sum(labels ~= wc_out);

cnn_model = fitcknn(train_cnn_feat, labels, 'NumNeighbors', 5);
cnn_out = predict(cnn_model, train_cnn_feat);
cnn_acc = 1 / sum(labels ~= cnn_out);

color_model = fitcknn(train_color, labels,  'NumNeighbors', 5);
color_out = predict(color_model, train_color);
color_acc = 1 / sum(labels ~= color_out);

prob_model = fitcknn(train_img_prob, labels, 'NumNeighbors', 5);
prob_out = predict(prob_model, train_img_prob);
prob_acc = 1 / sum(labels ~= prob_out);

total_acc = wc_acc + cnn_acc + color_acc + prob_acc;

out = (wc_acc * wc_out + cnn_acc * cnn_out + ...
    color_acc * color_out + prob_acc * prob_out) / total_acc; 
out = double(out >= 0.5);