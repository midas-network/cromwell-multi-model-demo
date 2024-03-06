#!/bin/bash

function git_repository_name(){
        IFS='/'
        read -a gitnamearr <<< "$git_repository_url"
        arrlen=${#gitnamearr[@]}
        IFS="."
        read -a repoarr <<< "${gitnamearr[arrlen-1]}"
        echo ${repoarr[0]}
}

git_repository_url=$1
git_repository_name
start=$2
stop=$3
num_samples=$4
pop_size=$5

echo "POP SIZE: ${pop_size}" 

cd $(git_repository_name)
# echo "${PWD}"
cp /midas-epispot/epispot_run.py . 
python epispot_run.py ${start} ${stop} ${num_samples} "${pop_size}"

