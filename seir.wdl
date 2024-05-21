version 1.0

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
}

workflow seirWorkflow {
    input {
        File setup_os_script
        String name_of_this_model_run
        File copy_cromwell_logs_script
        File copy_model_output_script
        File install_model_script
        File run_model_script
        String model_output_folder
        String model_output_file_types
        String model_runtime_docker
    }

    call run_seir {
        input:
            setup_os_script = setup_os_script,
            name_of_this_model_run = name_of_this_model_run,
            copy_cromwell_logs_script = copy_cromwell_logs_script,
            copy_model_output_script = copy_model_output_script,
            install_model_script = install_model_script,
            run_model_script = run_model_script,
            model_output_folder = model_output_folder,
            model_output_file_types = model_output_file_types,
            model_runtime_docker = model_runtime_docker,
            scatter_levels = 0
    }
}

