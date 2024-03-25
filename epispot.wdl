version 1.0

task run_epispot {
    input {
        File setup_os_script
        File install_git_script
        File install_python_script
        File install_model_script
        File run_model_script
        File run_model_executable
        String git_repository_url
        String start
        String stop
        String num_samples
        String pop_size
    }
    command {
        ${setup_os_script}
        ${install_git_script}
        ${install_python_script}
        ${install_model_script} "${git_repository_url}"
        ${run_model_script} "${run_model_executable}" "${git_repository_url}" "${start}" "${stop}" "${num_samples}" "${pop_size}"
    }
    runtime {
        docker: "python:3.9.18-slim-bullseye"
    }
    output {
#        File response = stdout()
        File epispot_results_txt = "results/comp_pop_over_time-${start}-${stop}-${num_samples}-${pop_size}.txt"
        File epispot_results_png = "results/comp_pop_over_time-${start}-${stop}-${num_samples}-${pop_size}.png"
    }
}

workflow epispotWorkflow {
    call run_epispot {
        input:
            setup_os_script = "./scripts/sh/setup_os.sh",
            install_git_script = "./scripts/sh/install_git.sh",
            install_python_script = "./scripts/sh/epispot/install_python_libraries.sh",
            install_model_script = "./scripts/sh/epispot/install_model.sh",
            run_model_script = "./scripts/sh/epispot/run_model.sh",
            run_model_executable = "./scripts/python/epispot_run.py",
            git_repository_url = "https://github.com/epispot/epispot",
            start = 0,
            stop = 50,
            num_samples = 200,
            pop_size = "1.78e6"
    }

    output {
#        File response = run_epispot.response
        File results_txt = run_epispot.epispot_results_txt
        File results_png = run_epispot.epispot_results_png
    }
}

