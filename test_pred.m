load('train_set/words_train.mat');
load('train_set/train_cnn_feat.mat');
load('train_set/train_color.mat');
load('train_set/train_img_prob.mat');

yhat = predict_labels(X, train_cnn_feat, train_img_prob, train_color, 0, 0);

% error
mean(yhat ~= Y)

%% EXPORT WELL CLASSIFIED WORDS AND THEIR COUNTS TO A FILE
% correct = full(X(yhat == Y,:));
% [topwords, indexes] = sort(sum(correct), 'descend');
% mat = sortrows([indexes;topwords]', 1);
% mat = mat(mat(:,2) ~= 0,:)
% 
% fid = fopen('topw', 'w');
% arrayfun(@(x) fprintf(fid, '%d,%d\n', mat(x,1), mat(x,2)), 1:size(mat,1))
% 
% fclose(fid)