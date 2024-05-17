version 1.0

task run_epispot {
    input {
        File setup_os_script
        File clone_repository_script
        File copy_cromwell_logs_script
        File copy_model_output_script
        Int start
        Int stop
        Int num_samples
        String pop_size
        String model_git_repository
        File install_model_script
        String name_of_this_model_run
        File run_model_script
        File model_executable
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

workflow epispotWorkflow {
    input {
        File setup_os_script
        File clone_repository_script
        File copy_cromwell_logs_script
        File copy_model_output_script
        String name_of_this_model_run
        Int start
        Int stop
        Int num_samples
        String pop_size
        String model_git_repository
        File install_model_script
        File run_model_script
        File model_executable
        String model_output_folder
        String model_output_file_types
        String model_runtime_docker
    }

    call run_epispot {
        input:
            setup_os_script = setup_os_script,
            clone_repository_script = clone_repository_script,
            copy_cromwell_logs_script = copy_cromwell_logs_script,
            copy_model_output_script = copy_model_output_script,
            name_of_this_model_run = name_of_this_model_run,
            start = start,
            stop = stop,
            num_samples = num_samples,
            pop_size = pop_size,
            model_git_repository = model_git_repository,
            install_model_script = install_model_script,
            run_model_script = run_model_script,
            model_executable = model_executable,
            model_output_folder = model_output_folder,
            model_output_file_types = model_output_file_types,
            model_runtime_docker = model_runtime_docker
    }

    output {
        Array[File] epispot_output_files = run_epispot.output_files
    }
}

