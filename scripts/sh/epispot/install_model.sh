#!/bin/bash

function git_repository_name(){
        IFS='/'
        read -a gitnamearr <<< "$git_repository_url"
        arrlen=${#gitnamearr[@]}
        IFS="."
        read -a repoarr <<< "${gitnamearr[arrlen-1]}"
        echo ${repoarr[0]}
}

pip install tabulate
pip install matplotlib~=3.8.3
pip install pandas
pip install numpy~=1.24.2
pip install dill~=0.3.6
pip install plotly~=5.14.1
pip install pytest~=7.4.0
pip install coverage~=7.4.1
pip install codecov~=2.1.12
pip install pdoc3~=0.10.0
pip install SciencePlots~=2.1.0
pip install lock-requirements~=0.1.1
pip install isort~=5.12.0
pip install pycodestyle~=2.10.0
pip install pep8-naming~=0.13.3
pip install flake8-noqa~=1.3.0
pip install flake8~=6.0.0
pip install ttws~=0.8.5
pip install autopep8~=2.0.1


CWD="$(pwd)"
git_repository_url=$1
git_repository_name

#git clone "$git_repository_url"

mkdir -p results

cd $(git_repository_name)
python setup.py install

cd $CWD
 
