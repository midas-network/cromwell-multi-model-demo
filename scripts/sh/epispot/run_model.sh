#!/bin/bash

function git_repository_name(){
        IFS='/'
        read -a gitnamearr <<< "$git_repository_url"
        arrlen=${#gitnamearr[@]}
        IFS="."
        read -a repoarr <<< "${gitnamearr[arrlen-1]}"
        echo ${repoarr[0]}
}

epispot_python=$1
git_repository_url=$2
git_repository_name
start=$3
stop=$4
num_samples=$5
pop_size=$6

echo "POP SIZE: ${pop_size}" 

cd $(git_repository_name)
echo "${epispot_python}"
# cp /midas-epispot/epispot_run.py . 
cp "${epispot_python}" . 
python epispot_run.py ${start} ${stop} ${num_samples} "${pop_size}"
#python "${epispot_python}" ${start} ${stop} ${num_samples} "${pop_size}"

