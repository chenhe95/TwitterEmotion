load('train_set/words_train.mat');
load('train_set/train_cnn_feat.mat');
load('train_set/train_color.mat');
load('train_set/train_img_prob.mat');

% will do preprocessing later
labels = Y;
word_counts_processed = X;

data_blocks = {word_counts_processed, train_cnn_feat, train_color, train_img_prob};

nb_wc = NaiveBayes.fit(word_counts_processed, labels);
nb_wc_out = predict(nb_wc, word_counts_processed);
nb_wc_acc = 1 / sum(labels ~= nb_wc_out);

nb_cnn = NaiveBayes.fit(train_cnn_feat, labels);
nb_cnn_out = predict(nb_cnn, train_cnn_feat);
nb_cnn_acc = 1 / sum(labels ~= nb_cnn_out);

nb_color = NaiveBayes.fit(train_color, labels);
nb_color_out = predict(nb_color, train_color);
nb_color_acc = 1 / sum(labels ~= nb_color_out);

nb_prob = NaiveBayes.fit(train_img_prob, labels);
nb_prob_out = predict(nb_prob, train_img_prob);
nb_prob_acc = 1 / sum(labels ~= nb_prob_out);

total_acc = nb_wc_acc + nb_cnn_acc + nb_color_acc + nb_prob_acc;

out = nb_wc_acc * nb_wc_out + nb_cnn_acc * nb_cnn_out + ...
    nb_color_acc * nb_color_out + nb_prob_acc * nb_prob_out; 
out = double(out >= 0.5);