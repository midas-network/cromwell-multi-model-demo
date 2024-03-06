version 1.0

task run_bayesian {
    input {
        File setup_os_script
        File install_python_script
        File install_model_script
        File run_model_script
        File move_results_script
        String git_repository_url
        String state
        String start_date
        String end_date
    }
    command {
        ${setup_os_script}
        ${install_python_script}
        ${install_model_script} "${git_repository_url}"
        ${run_model_script} "${git_repository_url}" "${state}" "${start_date}" "${end_date}"
        ${move_results_script}
    }
    runtime {
        docker: "python:3.6.15-bullseye"
    }
    output {
        File response = stdout()
        File bayesian_results = "bayesian-covid-model-demo/scripts/results/summary/${state}.txt"
    }
}

workflow bayesianWorkflow {
    call run_bayesian {
        input:
            setup_os_script = "./scripts/sh/bayesian/setup_os.sh",
            install_python_script = "./scripts/sh/bayesian/install_python_libraries.sh",
            install_model_script = "./scripts/sh/bayesian/install_model.sh",
            run_model_script = "./scripts/sh/bayesian/run_model.sh",
            move_results_script = "./scripts/sh/bayesian/move_results.sh",
            git_repository_url = "https://github.com/midas-network/bayesian-covid-model-demo.git",
            state = "GA",
            start_date = "2020-03-05",
            end_date = "2020-03-07"
    }

    output {
        File response = run_bayesian.response
        File results = run_bayesian.bayesian_results
    }
}

