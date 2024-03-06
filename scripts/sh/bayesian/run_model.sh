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
state=$2
start_date=$3
end_date=$4

cd $(git_repository_name)
cd scripts
python run_sir.py ${state} --start ${start_date} --end ${end_date}

