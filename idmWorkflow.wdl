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
    }
}

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
    }
}

task run_seir {
    input {
        File setup_os_script
        File install_SEIR_script
        File SEIR_script
        File move_results_script
    }
    command {
        ${setup_os_script}
        ${install_SEIR_script}
        R --slave --no-save --no-restore --no-site-file --no-environ -f ${SEIR_script} --args ""
        ${move_results_script}
    }
    runtime {
        docker: "npanicker/r-desolve:1.1"
    }
    output {
        File response = stdout()
    }
}

workflow idmWorkflow {
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

    call run_seir {
        input:
            setup_os_script = "./scripts/sh/seir/setup_os.sh",
            install_SEIR_script = "./scripts/sh/seir/install_SEIR.sh",
            SEIR_script = "./scripts/R/seir/SEIR.R",
            move_results_script = "./scripts/sh/seir/move_results.sh"
    }
}

