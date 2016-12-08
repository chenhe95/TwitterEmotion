#!/usr/bin/python

stopwords_en = 'common-english-words.txt'
stopwords_fr = 'common-french-words.txt'
stopwords_es = 'common-spanish-words.txt'
topwords = 'topwords.csv'

stop_words = []
top_words = []

small = []
unic  = []
http  = []
indexes = []
rt = []

f = open(stopwords_en, 'r')
for line in f.readlines():
    line = line.rstrip('\r\n')
    stop_words.append(line)

f.close()

f = open(stopwords_fr, 'r')
for line in f.readlines():
    line = line.rstrip('\r\n')
    stop_words.append(line)

f.close()

f = open(stopwords_es, 'r')
for line in f.readlines():
    line = line.rstrip('\r\n')
    stop_words.append(line)

f.close()

f = open(topwords, 'r')
for line in f.readlines():
    line = line.rstrip('\r\n')
    top_words.append(line)

    if len(line) == 1:
        small.append(top_words.index(line) + 1)

    unisub = '\u'
    if unisub in line:
        unic.append(top_words.index(line) + 1)

    httpsub = 'http'
    if httpsub in line:
        http.append(top_words.index(line) + 1)

    if line == 'rt':
        rt.append(top_words.index(line) + 1)

f.close()

for word in stop_words:
    try:
        indexes.append(top_words.index(word) + 1)
    except ValueError:
        print 'alo'

"""
print 'stop words: ' + str(indexes)
print 'word that has only 1 characters: ' + str(small)
print 'unicode words: ' + str(unic)
"""

merged = sorted(set(indexes + small + unic + rt))

#print 'all of them: ' + str(merged)

"""
# Get indexes of word that stays in the training set
a = range(10001)
dedans = [x for x in a[1:] if x not in merged]

#print dedans

words_from_matlab = 'topw'
word_cloud = 'word_cloud'

f = open(words_from_matlab, 'r')
w = open(word_cloud, 'w')

print len(merged)
print len(dedans)

p = 0

for line in f.readlines():
    line = line.rstrip('\r\n')
    nb = int(line.split(',')[1])

    word_to_write = dedans[p] - 1

    p += 1

    for n in range(nb):
        w.write(top_words[word_to_write] + ' ')

f.close()
w.close()
"""
