version 1.0

import "epispot.wdl" as epispot
import "bayesian.wdl" as bayesian
import "seir.wdl" as seir

# https://cromwell.readthedocs.io/en/stable/SubWorkflows/
# A sub-workflows is executed exactly as a task would be. This means that if another call depends on an output of a sub-workflow, this call will run when the whole sub-workflow completes (successfully).

workflow modelWorkflow {
    input {
        File setup_os_script
        File clone_repository_script
        File copy_cromwell_logs_script
        File copy_model_output_script
    }

    call epispot.epispotWorkflow {
        input:
            setup_os_script = setup_os_script,
            clone_repository_script = clone_repository_script,
            copy_cromwell_logs_script = copy_cromwell_logs_script,
            copy_model_output_script = copy_model_output_script
    }

    call bayesian.bayesianWorkflow {
        input:
            setup_os_script = setup_os_script,
            clone_repository_script = clone_repository_script,
            copy_cromwell_logs_script = copy_cromwell_logs_script,
            copy_model_output_script = copy_model_output_script
    }

    call seir.seirWorkflow {
        input:
            copy_cromwell_logs_script = copy_cromwell_logs_script,
            copy_model_output_script = copy_model_output_script    
    }

    output {
        Array[File] epispot_output_files = epispotWorkflow.epispot_output_files
        Array[File] bayesian_output_files = bayesianWorkflow.bayesian_output_files
        Array[File] seir_output_files = seirWorkflow.seir_output_files
    }
}

