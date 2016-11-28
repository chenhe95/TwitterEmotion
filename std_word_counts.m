function [word_counts_out] = std_word_counts(word_counts_in)

means = mean(word_counts_in);
stds = std(word_counts_in);
word_counts_out = bsxfun(@rdivide, bsxfun(@minus, word_counts_in, means), stds);

end