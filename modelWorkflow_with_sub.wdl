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

        String epispot_name_of_this_model_run
        Array[Int] epispot_start_array
        Array[Int] epispot_stop_array
        Array[Int] epispot_num_samples_array
        Array[String] epispot_pop_size_array
        String epispot_model_git_repository
        File epispot_install_model_script
        String epispot_name_of_this_model_run
        File epispot_run_model_script
        File epispot_model_executable
        String epispot_model_output_folder
        String epispot_model_output_file_types
        String epispot_model_runtime_docker

        String bayesian_name_of_this_model_run
        Array[String] bayesian_state_array
        Array[String] bayesian_start_date_array
        Array[String] bayesian_end_date_array
        String bayesian_model_git_repository
        File bayesian_install_model_script
        File bayesian_run_model_script
        String bayesian_model_output_folder
        String bayesian_model_output_file_types
        String bayesian_model_runtime_docker

        File seir_setup_os_script
        String seir_name_of_this_model_run
        File seir_install_model_script
        File seir_run_model_script
        String seir_model_output_folder
        String seir_model_output_file_types
        String seir_model_runtime_docker

    }

    call epispot.epispotWorkflow {
        input:
            setup_os_script = setup_os_script,
            clone_repository_script = clone_repository_script,
            copy_cromwell_logs_script = copy_cromwell_logs_script,
            copy_model_output_script = copy_model_output_script,
            name_of_this_model_run = epispot_name_of_this_model_run,
            start_array = epispot_start_array,
            stop_array = epispot_stop_array,
            num_samples_array = epispot_num_samples_array,
            pop_size_array = epispot_pop_size_array,
            model_git_repository = epispot_model_git_repository,
            install_model_script = epispot_install_model_script,
            run_model_script = epispot_run_model_script,
            model_executable = epispot_model_executable,
            model_output_folder = epispot_model_output_folder,
            model_output_file_types = epispot_model_output_file_types,
            model_runtime_docker = epispot_model_runtime_docker
    }

    call bayesian.bayesianWorkflow {
        input:
            setup_os_script = setup_os_script,
            clone_repository_script = clone_repository_script,
            copy_cromwell_logs_script = copy_cromwell_logs_script,
            copy_model_output_script = copy_model_output_script,
            name_of_this_model_run = bayesian_name_of_this_model_run,
            state_array = bayesian_state_array,
            start_date_array = bayesian_start_date_array,
            end_date_array = bayesian_end_date_array,
            model_git_repository = bayesian_model_git_repository,
            install_model_script = bayesian_install_model_script,
            run_model_script = bayesian_run_model_script,
            model_output_folder = bayesian_model_output_folder,
            model_output_file_types = bayesian_model_output_file_types,
            model_runtime_docker = bayesian_model_runtime_docker
    }

    call seir.seirWorkflow {
        input:
            copy_cromwell_logs_script = copy_cromwell_logs_script,
            copy_model_output_script = copy_model_output_script,
            name_of_this_model_run = seir_name_of_this_model_run,
            setup_os_script = seir_setup_os_script,
            install_model_script = seir_install_model_script,
            run_model_script = seir_run_model_script,
            model_output_folder = seir_model_output_folder,
            model_output_file_types = seir_model_output_file_types,
            model_runtime_docker = seir_model_runtime_docker
    }
}

