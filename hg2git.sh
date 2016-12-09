#!/bin/bash

#set -x
WORK=$(dirname $(which $0))

echo -e "\n\n##### Convert ../mercurial-repo to temp/git-repo\n\n"

# cleaning
cd $WORK
rm -Rf temp
mkdir -p temp/git-repo

# convert from mercurial to git
cd temp/git-repo
git init
$WORK/fast-export/hg-fast-export.sh -r $WORK/../mercurial-repo --force

if [[ $? -eq 0 ]] ; then
  echo "##### Repository converted"
else 
  echo "##### Conversion failed"
fi
