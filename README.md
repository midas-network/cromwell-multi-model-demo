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
 
 Edit model_input_parameters.json file to specify the run parameters for each model.  (Please note: the seir model has no parameters to specify.)

~~~
[
    {
        "model" : "epispot",
        "parameters": {
            "start": 0,
            "stop": 50,
            "num_samples": 200,
            "pop_size": "1.78e6"
        }
    },
    {
        "model" : "bayesian",
        "parameters": {
            "state": "GA",
            "start_date": "2020-03-05",
            "end_date": "2020-03-07"
        }
    },
    {
        "model" : "seir",
        "parameters": {
        }
    }
]
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

Results will be inside the results folder of this project:
~~~
~/../cromwell-multi-model-demo/results
~~~
