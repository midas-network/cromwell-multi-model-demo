#!/bin/bash

function git_repository_name(){
        IFS='/'
        read -a gitnamearr <<< "$git_repository_url"
        arrlen=${#gitnamearr[@]}
        IFS="."
        read -a repoarr <<< "${gitnamearr[arrlen-1]}"
        echo ${repoarr[0]}
}

# wget https://pypi.tuna.tsinghua.edu.cn/packages/71/42/5a97178a0e48d3647567917e72585c44d4d1cb521753af3b979e1c21e821/jaxlib-0.1.62-cp36-none-manylinux2010_x86_64.whl#sha256=8ae71b54b86f140a840b8c097b015e6fde5c323cc7b2ea716b2707a66370b01e
wget https://github.com/midas-network/jaxlib-0.1.62/raw/master/jaxlib-0.1.62-cp36-none-manylinux2010_x86_64.whl
pip install jaxlib-0.1.62-cp36-none-manylinux2010_x86_64.whl 

pip install patsy==0.5.1
pip install numpyro==0.6.0
pip install jax==0.2.3
pip install pandas==1.1.5
pip install matplotlib==3.3.4

CWD="$(pwd)"
git_repository_url=$1
git_repository_name

#git clone "$git_repository_url"

cd $(git_repository_name)
pip install -e .
cd $CWD
 
