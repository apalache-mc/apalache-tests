#!/usr/bin/env python
#
# Enumerate all subsets of a subset and generate quorum sets

n = 5

acceptors = ['"a1"', '"a2"', '"a3"', '"a4"', '"a5"']

def has_card(num, size):
    ones = 0
    for i in range(0, n):
        if num % 2 == 1:
            ones +=1
        
        num = num >> 1

    return size == ones

def num_to_list(num):
    res = []
    for i in range(0, n):
        if num % 2 == 1:
            res.append(acceptors[i])

        num = num >> 1

    return res
        

print "Quorums Q1:"
for i in range(0, 2 ** n):
    ls = num_to_list(i)
    if has_card(i, n / 2 + 1) and ('"a5"' in ls):
        print "{%s}, " % (", ".join(map(str, num_to_list(i))))

print "Quorums Q2:"
for i in range(0, 2 ** n):
    ls = num_to_list(i)
    if has_card(i, 2) and ('"a5"' in ls):
        print "{%s}, " % (", ".join(map(str, num_to_list(i))))

