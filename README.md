# cromwell-multi-model-demo

This project demostrates running multiple models using Cromwell, Python or R, and Docker.

## Cromwell:
[Cromwell](https://github.com/broadinstitute/cromwell) is an open-source Workflow Management System for bioinformatics.

We present two different methods of workflow design which result in the same output.
- A single workflow which calls multiple tasks (cromwell_workflow.sh)
- A workflow which calls multiple SubWorkflows (cromwell_workflow_with_sub.sh)

## Models:
- [Epispot](https://github.com/epispot/epispot): A Python package for the mathematical modeling of infectious diseases via compartmental models.
- [Bayesian compartmental models for COVID-19](https://github.com/midas-network/bayesian-covid-model-demo.git): This repository contains code for Bayesian estimation of compartmental models for COVID-19 using python, numpyro and jax.
- [SEIR](https://github.com/midas-network/cromwell-SEIR-basic) : This project demostrates running of a basic SEIR model using R.


## Execution:
### Pre-requisites:
 
 1. JAVA must be installed and be a minimum version of 11.
 2. Docker must also be installed and running.

Please note: The cromwell workflow script will check for these requirements and stop execution if they are not met.


### Input parameters:
 
 Edit **modelWorkflow_inputs.json** file to specify the run parameters for each model.  Alternatively, to execute a Cromwell example which includes sub workflows, please edit **modelWorkflow_inputs_with_sub.json**.

 
 First specify the name of the run for each model (do not include spaces).\
 For **Epispot**, provide the epispot_start_array, epispot_stop_array, epispot_num_samples_array and epispot_pop_size_array.\
 For **Bayesian**, provide bayesian_state_array, bayesian_start_date_array and bayesian_end_date_array.\
 For **SEIR**, only the name of the model run is necessary.

 All other input parameters specify the model particulars, such as git repository, output folder of the model, types of output produced, installation and  run scripts.

~~~
{
  "modelWorkflow.epispot_name_of_this_model_run": "epispot",
  "modelWorkflow.epispot_start_array": [0],
  "modelWorkflow.epispot_stop_array": [50],
  "modelWorkflow.epispot_num_samples_array": [200],
  "modelWorkflow.epispot_pop_size_array": ["1.78e6"],
  "modelWorkflow.run_epispot.model_executable": "./scripts/python/epispot_run.py",
  "modelWorkflow.run_epispot.model_git_repository": "https://github.com/epispot/epispot",
  "modelWorkflow.run_epispot.model_output_folder": "results",
  "modelWorkflow.run_epispot.model_output_file_types": "[png,txt]",
  "modelWorkflow.run_epispot.install_model_script": "./scripts/sh/epispot/install_model.sh",
  "modelWorkflow.run_epispot.run_model_script": "./scripts/sh/epispot/run_model.sh",
  "modelWorkflow.run_epispot.model_runtime_docker": "python:3.9.18-slim-bullseye",

  "modelWorkflow.bayesian_name_of_this_model_run": "bayesian",
  "modelWorkflow.bayesian_state_array": ["GA"],
  "modelWorkflow.bayesian_start_date_array": ["2020-03-05"],
  "modelWorkflow.bayesian_end_date_array": ["2020-03-30"],
  "modelWorkflow.run_bayesian.model_git_repository": "https://github.com/midas-network/bayesian-covid-model-demo.git",
  "modelWorkflow.run_bayesian.model_output_folder": "bayesian-covid-model-demo/scripts/results",
  "modelWorkflow.run_bayesian.model_output_file_types": "[npz,txt,png]",
  "modelWorkflow.run_bayesian.install_model_script": "./scripts/sh/bayesian/install_model.sh",
  "modelWorkflow.run_bayesian.run_model_script": "./scripts/sh/bayesian/run_model.sh",
  "modelWorkflow.run_bayesian.model_runtime_docker": "python:3.6.15-bullseye",

  "modelWorkflow.run_seir.name_of_this_model_run": "seir",
  "modelWorkflow.run_seir.model_output_folder": "./",
  "modelWorkflow.run_seir.model_output_file_types": "[pdf]",
  "modelWorkflow.run_seir.setup_os_script": "./scripts/sh/seir/setup_os.sh",
  "modelWorkflow.run_seir.install_model_script": "./scripts/sh/seir/install_model.sh",
  "modelWorkflow.run_seir.run_model_script": "./scripts/R/seir/SEIR.R",
  "modelWorkflow.run_seir.model_runtime_docker": "rocker/verse:latest",

  "modelWorkflow.setup_os_script": "./scripts/sh/setup_os.sh",
  "modelWorkflow.clone_repository_script": "./scripts/sh/clone_git_repository.sh",
  "modelWorkflow.copy_cromwell_logs_script": "./scripts/sh/copy_cromwell_logs.sh",
  "modelWorkflow.copy_model_output_script": "scripts/python/copy_model_output.py"
}
~~~

### To execute:
 From the command line execute the Cromwell workflow
~~~
./cromwell_workflow.sh
~~~
 Alternatively, to execute a Cromwell example which includes sub workflows
~~~
./cromwell_workflow_with_sub.sh
~~~


### Results:

Results will be inside the model_output folder of this project:
~~~
~/../cromwell-multi-model-demo/model_ouput
~~~
