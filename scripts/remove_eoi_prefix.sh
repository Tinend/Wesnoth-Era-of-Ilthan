#!/bin/sh

for file in `ls -1`
do
    if [ `expr $file : EOI_` == 4 ]
    then
	mv -v $file ${file:4}
    fi
done