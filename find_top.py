#!/usr/bin/python

stop_words = []
top_words = []
stopwords = 'common-english-words.txt'
topwords = 'topwords.csv'


f = open(stopwords, 'r')
for line in f.readlines():
    line = line.rstrip('\r\n')
    stop_words.append(line)

f.close()

small = []

f = open(topwords, 'r')
for line in f.readlines():
    line = line.rstrip('\r\n')
    top_words.append(line)

    if len(line) == 1:
        small.append(top_words.index(line) + 1)


f.close()

indexes = []

for word in stop_words:
    try:
        indexes.append(top_words.index(word) + 1)
    except ValueError:
        print 'alo'

print 'stop words: ' + str(indexes)
print 'word that has only 1 characters: ' + str(small)

merged = [j for i in zip(indexes,small) for j in i]

print 'all of them: ' + str(merged)
