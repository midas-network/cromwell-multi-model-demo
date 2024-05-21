version 1.0

task run_epispot {
    input {
        File setup_os_script
        File clone_repository_script
        File copy_cromwell_logs_script
        File copy_model_output_script
        String model_git_repository
        File install_model_script
        String name_of_this_model_run
        File run_model_script
        File model_executable
        Int start
        Int stop
        Int num_samples
        String pop_size
        String model_output_folder
        String model_output_file_types
        String model_runtime_docker
        Int scatter_levels
    }

    String model_output_file_listing = "${name_of_this_model_run}_output_files.txt"

    command {
        ${setup_os_script}
        ${clone_repository_script} "${model_git_repository}"
        ${install_model_script} "${model_git_repository}"
        ${run_model_script} "${model_executable}" "${model_git_repository}" "${start}" "${stop}" "${num_samples}" "${pop_size}"
        python3 ${copy_model_output_script} "${scatter_levels}" "${model_output_folder}" "${model_output_file_types}" "${model_output_file_listing}" "${name_of_this_model_run}"
        ${copy_cromwell_logs_script} "${scatter_levels}" "${model_output_folder}" "${name_of_this_model_run}"
    }
    runtime {
        docker: "${model_runtime_docker}"
    }
    output {
        Array[File] output_files = read_lines(model_output_file_listing)
    }
}

task run_bayesian {
    input {
        File setup_os_script
        File clone_repository_script
        File copy_cromwell_logs_script
        File copy_model_output_script
        String model_git_repository
        File install_model_script
        String name_of_this_model_run
        File run_model_script
        String state
        String start_date
        String end_date
        String model_output_folder
        String model_output_file_types
        String model_runtime_docker
        Int scatter_levels
    }

    String model_output_file_listing = "${name_of_this_model_run}_output_files.txt"

    command {
        ${setup_os_script}
        ${clone_repository_script} "${model_git_repository}"
        ${install_model_script} "${model_git_repository}"
        ${run_model_script} "${model_git_repository}" "${state}" "${start_date}" "${end_date}"
        python3 ${copy_model_output_script} "${scatter_levels}" "${model_output_folder}" "${model_output_file_types}" "${model_output_file_listing}" "${name_of_this_model_run}"
        ${copy_cromwell_logs_script} "${scatter_levels}" "${model_output_folder}" "${name_of_this_model_run}"
    }
    runtime {
        docker: "${model_runtime_docker}"
    }
    output {
        Array[File] output_files = read_lines(model_output_file_listing)
    }
}

task run_seir {
    input {
        File setup_os_script
        File copy_cromwell_logs_script
        File copy_model_output_script
        File install_model_script
        String name_of_this_model_run
        File run_model_script
        String model_output_folder
        String model_output_file_types
        String model_runtime_docker
        Int scatter_levels
    }

    String model_output_file_listing = "${name_of_this_model_run}_output_files.txt"

    command {
        ${setup_os_script}
        ${install_model_script}
        R --slave --no-save --no-restore --no-site-file --no-environ -f ${run_model_script} --args ""
        python3 ${copy_model_output_script} "${scatter_levels}" "${model_output_folder}" "${model_output_file_types}" "${model_output_file_listing}" "${name_of_this_model_run}"
        ${copy_cromwell_logs_script} "${scatter_levels}" "${model_output_folder}" "${name_of_this_model_run}"
    }
    runtime {
        docker: "${model_runtime_docker}"
    }
    output {
        Array[File] output_files = read_lines(model_output_file_listing)
    }
}

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
        String bayesian_name_of_this_model_run
        Array[String] bayesian_state_array
        Array[String] bayesian_start_date_array
        Array[String] bayesian_end_date_array

    }

    scatter (start in epispot_start_array) {
        scatter (stop in epispot_stop_array) {
            scatter (num_samples in epispot_num_samples_array) {
                scatter (pop_size in epispot_pop_size_array) {

                    String epispot_name = epispot_name_of_this_model_run + "_" + start + "_" + stop + "_" + num_samples + "_" + pop_size 
                    Int epispot_scatter_levels = 4

                    call run_epispot {
                        input:
                            setup_os_script = setup_os_script,
                            clone_repository_script = clone_repository_script,
                            copy_cromwell_logs_script = copy_cromwell_logs_script,
                            copy_model_output_script = copy_model_output_script,
                            name_of_this_model_run = epispot_name,
                            start = start,
                            stop = stop,
                            num_samples = num_samples,
                            pop_size = pop_size,
                            scatter_levels = epispot_scatter_levels
                    }
                }
            }
        }
    }

    scatter (state in bayesian_state_array) {
        scatter (start_date in bayesian_start_date_array) {
            scatter (end_date in bayesian_end_date_array) {

                String bayesian_name = bayesian_name_of_this_model_run + "_" + state + "_" + start_date + "_" + end_date
                Int bayesian_scatter_levels = 3

                call run_bayesian {
                    input:
                        setup_os_script = setup_os_script,
                        clone_repository_script = clone_repository_script,
                        copy_cromwell_logs_script = copy_cromwell_logs_script,
                        copy_model_output_script = copy_model_output_script,
                        name_of_this_model_run = bayesian_name,
                        state = state,
                        start_date = start_date,
                        end_date = end_date,
                        scatter_levels = bayesian_scatter_levels
                }
            }
        }
    }

    call run_seir {
        input:
            copy_cromwell_logs_script = copy_cromwell_logs_script,
            copy_model_output_script = copy_model_output_script,
            scatter_levels = 0
    }
}

