#!/bin/bash

#set -x
WORK=$(dirname $(which $0))

# info
echo -ne "\n\n##### First you must remove sensitive data and text from source repository workdir and then commit.\n##### This script do not remove data and text from last commit.\n\n"

# remove sensitive data from git repository
cd $WORK/temp
pwd
git clone --mirror git-repo
cd $WORK
java -jar bfg-1.12.14.jar -D "`cat sensitive.txt`" temp/git-repo.git

# remove sensitive text from files in git repository
cd $WORK
java -jar bfg-1.12.14.jar --replace-text replacements.txt temp/git-repo.git

# save removal work
cd temp/git-repo.git && git reflog expire --expire=now --all && git gc --prune=now --aggressive

# save final repository
cd $WORK/temp
git clone git-repo.git git-repo-after
rm -Rf git-repo.git

# change author information in log
cd $WORK/temp/git-repo-after
git checkout
git filter-branch -f --env-filter "
    GIT_AUTHOR_NAME='Marek Ramotowski'
    GIT_AUTHOR_EMAIL='ma-ra@users.noreply.github.com'
    GIT_COMMITTER_NAME='Marek Ramotowski'
    GIT_COMMITTER_EMAIL='ma-ra@users.noreply.github.com'
  " HEAD

# show files in repository to check removal
cd $WORK/temp/git-repo-after
git log --diff-filter=D --summary | grep delete
