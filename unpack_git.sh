#!/bin/bash

#set -x
WORK=$(dirname $(which $0))

# cleaning
rm -Rf $WORK/temp/unpack_git
mkdir -p $WORK/temp/unpack_git

# copy git repository for each revision
cd $WORK/temp/git-repo-after/
counter=0;
for i in `git log --pretty="%H"` ; do
	((counter++))
    echo "$counter. Copy ==> /temp/unpack_git/$i"
	mkdir -p "$WORK/temp/unpack_git/${counter}_${i}"
	git archive $i | tar -xC "$WORK/temp/unpack_git/${counter}_${i}/"
done
