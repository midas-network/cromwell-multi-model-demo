#!/bin/bash

model_output=$1
model_name=$2

if [[ ! -d /midas/model_output/"$model_name" ]]; 
then
  mkdir /midas/model_output/"$model_name"
fi

echo "Providing easy access to stderr and stdout..."
cp -f stderr /midas/model_output/"$model_name"
cp -f stdout /midas/model_output/"$model_name"

echo "Verifying $model_output folder exists from sucessful run..."
if [[ -d "$model_output" ]]; 
then
  echo "  model_output folder found!";
  # cp -r "$model_output" /midas/
else
  echo "  Error: Couldn't find $model_output folder.  The run was not successful."
  exit 1
fi
