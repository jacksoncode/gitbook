#!/bin/sh
files=`ls -l *.html|awk '{print $9}'`

for i in $files
do
    j=`ls $i|sed 's/.html//g'`
    #echo $i
    #echo $j
    pandoc $i -o $j.md
done
