#!/bin/sh

grep -ve - sieved.log > filtered.log

cat /dev/null > bar.txt

NUM=`grep 251 filtered.log | wc -l`

echo Repeats: $NUM

for i in $(seq 1 $NUM)
do
    cat primes.txt >> bar.txt
done

diff -u bar.txt filtered.log
