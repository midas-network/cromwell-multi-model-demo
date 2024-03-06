version 1.0

task run_epispot {
    input {
        File setup_os_script
        File install_python_script
        File install_model_script
        File run_model_script
        File move_results_script
        String git_repository_url
        String start
        String stop
        String num_samples
        String pop_size
    }
    command {
        ${setup_os_script}
        ${install_python_script}
        ${install_model_script} "${git_repository_url}"
        ${run_model_script} "${git_repository_url}" "${start}" "${stop}" "${num_samples}" "${pop_size}"
        ${move_results_script}
    }
    runtime {
        docker: "python:3.9.18-slim-bullseye"
    }
    output {
        File response = stdout()
        File epispot_results = "results/comp_pop_over_time-${start}-${stop}-${num_samples}-${pop_size}.txt"
    }
}

workflow epispotWorkflow {
    call run_epispot {
        input:
            setup_os_script = "./scripts/sh/epispot/setup_os.sh",
            install_python_script = "./scripts/sh/epispot/install_python_libraries.sh",
            install_model_script = "./scripts/sh/epispot/install_model.sh",
            run_model_script = "./scripts/sh/epispot/run_model.sh",
            move_results_script = "./scripts/sh/epispot/move_results.sh",
            git_repository_url = "https://github.com/epispot/epispot",
            start = 0,
            stop = 50,
            num_samples = 200,
            pop_size = "1.78e6"
    }

    output {
        File response = run_epispot.response
        File results = run_epispot.epispot_results
    }
}

