version 1.0

import "epispot.wdl" as epispot
import "bayesian.wdl" as bayesian
import "seir.wdl" as seir

task testResults {
    input {
        File results
    }
    command {
        more ${results}
    }
    output {
        String out = read_string(stdout())
    }
}

# https://cromwell.readthedocs.io/en/stable/SubWorkflows/
# A sub-workflows is executed exactly as a task would be. This means that if another call depends on an output of a sub-workflow, this call will run when the whole sub-workflow completes (successfully).

workflow idmWorkflow {
    call epispot.epispotWorkflow {}
    call bayesian.bayesianWorkflow {}
    call seir.seirWorkflow {}

    output {
        File epispot_response = epispotWorkflow.response
        File epispot_results = epispotWorkflow.results
        File bayesian_response = bayesianWorkflow.response
        File bayesian_results = bayesianWorkflow.results
        File seir_response = seirWorkflow.response
        File seir_results = seirWorkflow.results

    }

    call testResults {
        input: 
            results = epispot_results
    }

}

