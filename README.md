# cromwell-multi-model-demo

This project demostrates running multiple models using Cromwell, Python or R, and Docker.

## Pre-requisites:
 
 1. JAVA must be installed and be a minimum version of 11.
 2. Docker must also be installed and running.

Please note: The cromwell workflow script will check for these requirements and stop execution if they are not met.


## To execute:
 
 1. Edit idmWorkflow.wdl using a text editor to specify the run paramters 

 Epispot (lines 88-91)
~~~
start = 0,
stop = 50,
num_samples = 200,
pop_size = "1.78e6"
~~~
 Bayesian (lines 102-104)
~~~
state = "GA",
start_date = "2020-03-05",
end_date = "2020-03-07"
~~~


 2. From the command line execute the Cromwell workflow
~~~
./cromwell_workflow.sh
~~~


## Results:

Results will be inside the results folder of this project:
~~~
~/../cromwell-multi-model-demo/results
~~~
