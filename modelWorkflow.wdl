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
    }

    String model_output_file_listing = "${name_of_this_model_run}_output_files.txt"

    command {
        ${setup_os_script}
        ${clone_repository_script} "${model_git_repository}"
        ${install_model_script} "${model_git_repository}"
        ${run_model_script} "${model_executable}" "${model_git_repository}" "${start}" "${stop}" "${num_samples}" "${pop_size}"
        python3 ${copy_model_output_script} "${model_output_folder}" "${model_output_file_types}" "${model_output_file_listing}" "${name_of_this_model_run}"
        ${copy_cromwell_logs_script} "${model_output_folder}" "${name_of_this_model_run}"
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
    }

    String model_output_file_listing = "${name_of_this_model_run}_output_files.txt"

    command {
        ${setup_os_script}
        ${clone_repository_script} "${model_git_repository}"
        ${install_model_script} "${model_git_repository}"
        ${run_model_script} "${model_git_repository}" "${state}" "${start_date}" "${end_date}"
        python3 ${copy_model_output_script} "${model_output_folder}" "${model_output_file_types}" "${model_output_file_listing}" "${name_of_this_model_run}"
        ${copy_cromwell_logs_script} "${model_output_folder}" "${name_of_this_model_run}"
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
    }

    String model_output_file_listing = "${name_of_this_model_run}_output_files.txt"

    command {
        ${setup_os_script}
        ${install_model_script}
        R --slave --no-save --no-restore --no-site-file --no-environ -f ${run_model_script} --args ""
        python3 ${copy_model_output_script} "${model_output_folder}" "${model_output_file_types}" "${model_output_file_listing}" "${name_of_this_model_run}"
        ${copy_cromwell_logs_script} "${model_output_folder}" "${name_of_this_model_run}"
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
    }

    call run_epispot {
        input:
            setup_os_script = setup_os_script,
            clone_repository_script = clone_repository_script,
            copy_cromwell_logs_script = copy_cromwell_logs_script,
            copy_model_output_script = copy_model_output_script
    }

    call run_bayesian {
        input:
            setup_os_script = setup_os_script,
            clone_repository_script = clone_repository_script,
            copy_cromwell_logs_script = copy_cromwell_logs_script,
            copy_model_output_script = copy_model_output_script
    }

    call run_seir {
        input:
            copy_cromwell_logs_script = copy_cromwell_logs_script,
            copy_model_output_script = copy_model_output_script
    }

    output {
        Array[File] epispot_output_files = run_epispot.output_files
        Array[File] bayesian_output_files = run_bayesian.output_files
        Array[File] seir_output_files = run_seir.output_files
    }
}

