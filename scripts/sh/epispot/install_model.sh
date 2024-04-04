#!/bin/bash

function git_repository_name(){
        IFS='/'
        read -a gitnamearr <<< "$git_repository_url"
        arrlen=${#gitnamearr[@]}
        IFS="."
        read -a repoarr <<< "${gitnamearr[arrlen-1]}"
        echo ${repoarr[0]}
}

CWD="$(pwd)"
git_repository_url=$1
git_repository_name

git clone "$git_repository_url"

mkdir -p results

cd $(git_repository_name)
python setup.py install

cd $CWD
 
