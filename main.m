load('train_set/words_train.mat');
load('train_set/train_cnn_feat.mat');
load('train_set/train_color.mat');
load('train_set/train_img_prob.mat');
load('train_set/raw_tweets_train.mat');

addpath('./DL_toolbox/util','./DL_toolbox/NN','./DL_toolbox/DBN');

n_examples = size(X, 1);

% indices for 10f cross validation
K = 10;
n_blocks = 4;
errors = zeros(K, 1);
cv_10f_indices = crossvalind('Kfold', n_examples, K);

labels = Y;


%% WORD PRE-PROCESSING
% Keeping only a binary variable 0/1 indicating presence of a word
word_counts_processed = full(double(X ~= 0));
%word_counts_processed = full(double(X));

% Removing stop words, single characters, unicode, and urls
preprocess = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 15, 16, 17, 18, 19, 20, 21, 22, 25, 27, 29, 33, 35, 36, 37, 38, 40, 46, 47, 48, 49, 52, 53, 54, 55, 57, 60, 61, 63, 64, 67, 70, 72, 74, 77, 78, 82, 84, 87, 91, 92, 93, 95, 96, 101, 102, 105, 108, 116, 119, 126, 129, 130, 132, 138, 139, 143, 144, 145, 148, 149, 150, 151, 161, 163, 169, 171, 173, 175, 177, 178, 182, 185, 194, 197, 199, 201, 202, 204, 206, 209, 214, 215, 216, 224, 226, 236, 238, 239, 245, 253, 263, 266, 297, 298, 304, 312, 314, 325, 326, 329, 337, 345, 347, 348, 352, 354, 356, 366, 375, 381, 384, 398, 399, 445, 446, 448, 450, 453, 455, 467, 468, 469, 473, 475, 476, 477, 480, 484, 489, 498, 507, 508, 525, 530, 556, 557, 564, 565, 572, 578, 580, 591, 592, 597, 600, 609, 619, 626, 647, 656, 662, 667, 669, 673, 675, 677, 681, 697, 704, 712, 715, 721, 736, 740, 749, 753, 767, 777, 780, 785, 841, 867, 868, 891, 892, 902, 915, 919, 940, 954, 955, 956, 971, 980, 981, 982, 989, 993, 1004, 1020, 1028, 1029, 1033, 1042, 1055, 1059, 1068, 1081, 1114, 1124, 1135, 1146, 1150, 1187, 1222, 1230, 1233, 1234, 1246, 1253, 1254, 1272, 1280, 1281, 1294, 1341, 1342, 1346, 1347, 1353, 1354, 1366, 1368, 1373, 1379, 1397, 1400, 1420, 1433, 1462, 1463, 1464, 1479, 1484, 1493, 1496, 1520, 1557, 1558, 1559, 1579, 1591, 1596, 1624, 1625, 1661, 1665, 1666, 1667, 1680, 1685, 1690, 1692, 1718, 1719, 1733, 1734, 1735, 1775, 1776, 1777, 1823, 1845, 1854, 1869, 1895, 1901, 1907, 1915, 1916, 1917, 1918, 1964, 1972, 1974, 1978, 1979, 2016, 2032, 2060, 2074, 2085, 2090, 2091, 2095, 2136, 2157, 2158, 2159, 2160, 2161, 2205, 2216, 2217, 2257, 2267, 2272, 2287, 2323, 2340, 2341, 2342, 2343, 2344, 2384, 2416, 2425, 2426, 2481, 2492, 2517, 2519, 2520, 2521, 2567, 2587, 2604, 2618, 2619, 2620, 2702, 2704, 2705, 2706, 2707, 2708, 2709, 2757, 2790, 2803, 2804, 2872, 2925, 2929, 2930, 2931, 3012, 3022, 3067, 3069, 3070, 3071, 3072, 3073, 3074, 3075, 3076, 3077, 3152, 3153, 3165, 3208, 3212, 3213, 3214, 3215, 3307, 3319, 3323, 3335, 3348, 3364, 3384, 3397, 3398, 3399, 3400, 3401, 3402, 3403, 3404, 3405, 3406, 3454, 3524, 3540, 3544, 3560, 3564, 3565, 3566, 3567, 3568, 3569, 3570, 3669, 3670, 3673, 3698, 3717, 3735, 3768, 3769, 3770, 3771, 3772, 3773, 3872, 3875, 3883, 3886, 3910, 3940, 3949, 3981, 3982, 3983, 3984, 3985, 3986, 3987, 3988, 3989, 3990, 3999, 4019, 4148, 4153, 4211, 4214, 4223, 4229, 4230, 4231, 4232, 4373, 4388, 4399, 4404, 4409, 4457, 4463, 4467, 4523, 4524, 4525, 4526, 4527, 4528, 4529, 4530, 4531, 4532, 4533, 4534, 4535, 4536, 4537, 4538, 4539, 4540, 4541, 4542, 4550, 4701, 4716, 4734, 4735, 4798, 4874, 4880, 4881, 4882, 4883, 4884, 4885, 4886, 4887, 4888, 4889, 4890, 4891, 4892, 5063, 5064, 5083, 5133, 5139, 5208, 5225, 5263, 5266, 5267, 5268, 5269, 5270, 5271, 5272, 5273, 5274, 5275, 5276, 5277, 5278, 5279, 5280, 5281, 5282, 5340, 5389, 5491, 5492, 5493, 5528, 5531, 5550, 5563, 5569, 5590, 5606, 5705, 5762, 5763, 5764, 5765, 5766, 5767, 5768, 5769, 5770, 5771, 5772, 5773, 5774, 5775, 5776, 5777, 5778, 5779, 5780, 5781, 5782, 5783, 5784, 5785, 5786, 5787, 5788, 5789, 5790, 5791, 6058, 6059, 6080, 6093, 6137, 6181, 6195, 6270, 6304, 6313, 6314, 6382, 6383, 6384, 6385, 6386, 6387, 6388, 6389, 6390, 6391, 6392, 6393, 6394, 6395, 6396, 6397, 6398, 6399, 6400, 6401, 6402, 6403, 6404, 6405, 6406, 6407, 6408, 6409, 6410, 6411, 6412, 6413, 6497, 6645, 6651, 6754, 6755, 6770, 6774, 6776, 6820, 6849, 6914, 6919, 6921, 6928, 6950, 6972, 7017, 7018, 7058, 7076, 7099, 7101, 7177, 7181, 7183, 7184, 7185, 7186, 7187, 7188, 7189, 7190, 7191, 7192, 7193, 7194, 7195, 7196, 7197, 7198, 7199, 7200, 7201, 7202, 7203, 7204, 7205, 7206, 7207, 7208, 7209, 7210, 7211, 7212, 7213, 7214, 7215, 7216, 7217, 7218, 7219, 7220, 7221, 7222, 7223, 7224, 7225, 7226, 7361, 7508, 7550, 7554, 7559, 7568, 7673, 7693, 7718, 7727, 7751, 7763, 7776, 7777, 7778, 7805, 7846, 7849, 7862, 7863, 7864, 7877, 7886, 7890, 7906, 7922, 7960, 7975, 7986, 7999, 8018, 8020, 8031, 8076, 8179, 8182, 8194, 8195, 8196, 8197, 8198, 8199, 8200, 8201, 8202, 8203, 8204, 8205, 8206, 8207, 8208, 8209, 8210, 8211, 8212, 8213, 8214, 8215, 8216, 8217, 8218, 8219, 8220, 8221, 8222, 8223, 8224, 8225, 8226, 8227, 8228, 8229, 8230, 8231, 8232, 8233, 8234, 8235, 8236, 8237, 8238, 8239, 8240, 8241, 8242, 8243, 8244, 8245, 8246, 8247, 8248, 8249, 8250, 8251, 8252, 8253, 8254, 8364, 8600, 8656, 8657, 8693, 8850, 8851, 8889, 8901, 8945, 8987, 8990, 9059, 9145, 9180, 9186, 9201, 9239, 9245, 9259, 9313, 9393, 9417, 9418, 9424, 9438, 9455, 9479, 9506, 9518, 9560, 9561, 9590, 9599, 9610, 9614, 9629, 9634, 9652, 9653, 9654, 9655, 9656, 9657, 9658, 9659, 9660, 9661, 9662, 9663, 9664, 9665, 9666, 9667, 9668, 9669, 9670, 9671, 9672, 9673, 9674, 9675, 9676, 9677, 9678, 9679, 9680, 9681, 9682, 9683, 9684, 9685, 9686, 9687, 9688, 9689, 9690, 9691, 9692, 9693, 9694, 9695, 9696, 9697, 9698, 9699, 9700, 9701, 9702, 9703, 9704, 9705, 9706, 9707, 9708, 9709, 9710, 9711, 9712, 9713, 9779, 9899];
word_counts_processed(:, preprocess) = [];

% remove unfrequent words
% not_frequent = find(sum(word_counts_processed) < 2);
% word_counts_processed(:, not_frequent) = [];

% remove 0 cols
c_removed = find(~any(word_counts_processed, 1));
word_counts_processed(:, c_removed) = [];

%% K-FOLD VALIDATION LOOP
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
%     %% SEMI-SUPERVISED: FINDING PCA
% %     cnn_feat_train_meaned = bsxfun(@minus, cnn_feat_train, mean(cnn_feat_train));
% %     cnn_feat_test_meaned = bsxfun(@minus, cnn_feat_test, mean(cnn_feat_test));
% %
% %     cnn_feat_train_cov = (cnn_feat_train_meaned' * cnn_feat_train_meaned)./size(cnn_feat_train,1);
% %
% %     [coeff_train, latent, exp] = pcacov(cnn_feat_train_cov);
% %
% %     cnn_score_train = cnn_feat_train_meaned * coeff_train;
% %     cnn_score_test = cnn_feat_test_meaned * coeff_train;
%
%     %% STANDARDIZATION:
% %     wc_train_meaned = bsxfun(@minus, word_counts_train, mean(word_counts_train));
% %     wc_test_meaned = bsxfun(@minus, word_counts_test, mean(word_counts_test)); 
%
%     %% DISCRIMINATIVE: SVM ON WORDS
% %     wc_model = fitcsvm(word_counts_train, labels_train);
% %     wc_model = fitcsvm(word_counts_train, labels_train);
% %     wc_out = predict(wc_model, word_counts_test);
% %     wc_acc = 1 / sum(labels_test ~= wc_out);
%
%     %% DISCRIMINATIVE: NB ON WORDS
%     wc_model = fitcnb(word_counts_train, labels_train, 'Distribution', 'mn');
%     wc_out = predict(wc_model, word_counts_test);
%     wc_acc = 1 / sum(labels_test ~= wc_out);
%
%     %% DISCRIMINATIVE: KNN ON WORDS
% %     wc_model = fitcknn(word_counts_train, labels_train, 'NumNeighbors', 5);
% %     wc_out = predict(wc_model, word_counts_test);
% %     wc_acc = 1 / sum(labels_test ~= wc_out);
%
% %     cnn_model = train(labels_train, sparse(cnn_score_train), ['-s 0', 'col']);
% %     cnn_out = predict(labels_test, sparse(cnn_score_test), model, ['-q', 'col']);
% %     cnn_acc = 1 / sum(labels_test ~= cnn_out);
%
%     %% DISCRIMINATIVE: NB ON CNN
% %     cnn_model = fitcnb(cnn_feat_train + 1, labels_train, 'Distribution', 'mn');
% %     cnn_out = predict(cnn_model, cnn_feat_test + 1);
% %     cnn_acc = 1 / sum(labels_test ~= cnn_out);
%
%     %% DISCRIMINATIVE: KNN ON CNN
% %     cnn_model = fitcknn(cnn_feat_train, labels_train, 'NumNeighbors', 5);
% %     cnn_out = predict(cnn_model, cnn_feat_test);
% %     cnn_acc = 1 / sum(labels_test ~= cnn_out);
%
%     %% DISCRIMINATIVE: NB ON COLOR
% %     color_model = fitcnb(color_feat_train + 1, labels_train, 'Distribution', 'mn');
% %     color_out = predict(color_model, color_feat_test + 1);
% %     color_acc = 1 / sum(labels_test ~= color_out);
%
%     %% DISCRIMINATIVE: KNN ON COLOR
% %     color_model = fitcknn(color_feat_train, labels_train, 'NumNeighbors', 5);
% %     color_out = predict(color_model, color_feat_test);
% %     color_acc = 1 / sum(labels_test ~= color_out);
%
%     %% DISCRIMINATIVE: NB ON PROB
% %     prob_model = fitcnb(prob_feat_train, labels_train, 'Distribution', 'mn');
% %     prob_out = predict(prob_model, prob_feat_test);
% %     prob_acc = 1 / sum(labels_test ~= prob_out);
%
%     %% DISCRIMINATIVE: KNN ON PROB
% %     prob_model = fitcknn(prob_feat_train, labels_train, 'NumNeighbors', 5);
% %     prob_out = predict(prob_model, prob_feat_test);
% %     prob_acc = 1 / sum(labels_test ~= sign(prob_out));
%
% %     p = perceptron;
% %     prob_model = train(p, full(color_feat_train'), full(labels_train'));
% %     prob_out = prob_model(full(color_feat_test'), 'useParallel', 'yes');
% %     prob_acc = 1 / sum(labels_test ~= sign(prob_out));
%
% %     total_acc = wc_acc + cnn_acc + color_acc + prob_acc;
% %
% %     Y_hat = (wc_acc * wc_out + cnn_acc * cnn_out + color_acc * color_out + prob_acc * prob_out) / total_acc; 
% %     Y_hat = double(Y_hat >= 0.5);
% %
% %    errors(i) = mean(Y_hat ~= labels_test);
%    errors(i) = mean(sign(wc_out) ~= labels_test);
% end
%
% error = mean(errors);

%     wc_model = TreeBagger(100, word_counts_processed, labels, 'Method', 'classification');
%     wc_out = str2double(predict(wc_model, word_counts_processed));
%     wc_acc = 1 / sum(labels ~= wc_out)
%     error = mean(wc_out ~= labels)

wc_model = fitcnb(word_counts_processed, labels, 'Distribution', 'mn');

save(['models' '.mat'], 'wc_model', 'c_removed', 'preprocess');
