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

task run_bayesian {
    input {
        File setup_os_script
        File install_git_script
        File install_python_script
        File install_model_script
        File run_model_script
        String git_repository_url
        String state
        String start_date
        String end_date
    }
    command {
        ${setup_os_script}
        ${install_git_script}
        ${install_python_script}
        ${install_model_script} "${git_repository_url}"
        ${run_model_script} "${git_repository_url}" "${state}" "${start_date}" "${end_date}"
    }
    runtime {
        docker: "python:3.6.15-bullseye"
    }
    output {
#        File response = stdout()
        File results_samples = "bayesian-covid-model-demo/scripts/results/samples/${state}.npz"
        File results_summary = "bayesian-covid-model-demo/scripts/results/summary/${state}.txt"
        File results_vis_r0 = "bayesian-covid-model-demo/scripts/results/vis/${state}_R0.png"
        File results_vis_scale_lin_daily_False_T_28 = "bayesian-covid-model-demo/scripts/results/vis/${state}_scale_lin_daily_False_T_28.png"
        File results_vis_scale_lin_daily_False_T_56 = "bayesian-covid-model-demo/scripts/results/vis/${state}_scale_lin_daily_False_T_56.png"
        File results_vis_scale_lin_daily_True_T_28 = "bayesian-covid-model-demo/scripts/results/vis/${state}_scale_lin_daily_True_T_28.png"
        File results_vis_scale_lin_daily_True_T_56 = "bayesian-covid-model-demo/scripts/results/vis/${state}_scale_lin_daily_True_T_56.png"
        File results_vis_scale_log_daily_False_T_28 = "bayesian-covid-model-demo/scripts/results/vis/${state}_scale_log_daily_False_T_28.png"
        File results_vis_scale_log_daily_False_T_56 = "bayesian-covid-model-demo/scripts/results/vis/${state}_scale_log_daily_False_T_56.png"
        File results_vis_scale_log_daily_True_T_28 = "bayesian-covid-model-demo/scripts/results/vis/${state}_scale_log_daily_True_T_28.png"
        File results_vis_scale_log_daily_True_T_56 = "bayesian-covid-model-demo/scripts/results/vis/${state}_scale_log_daily_True_T_56.png"
    }
}

task run_seir {
    input {
        File setup_os_script
        File install_SEIR_script
        File SEIR_script
    }
    command {
        ${setup_os_script}
        ${install_SEIR_script}
        R --slave --no-save --no-restore --no-site-file --no-environ -f ${SEIR_script} --args ""
    }
    runtime {
        docker: "npanicker/r-desolve:1.1"
    }
    output {
#        File response = stdout()
        File seir_results = "Rplots.pdf"
    }
}

task moveResults {
    input {
        File move_results_script
        File epispot_results_txt
        File epispot_results_png
        File bayesian_results_samples
        File bayesian_results_summary
        File bayesian_results_vis_r0
        File bayesian_results_vis_scale_lin_daily_False_T_28
        File bayesian_results_vis_scale_lin_daily_False_T_56
        File bayesian_results_vis_scale_lin_daily_True_T_28
        File bayesian_results_vis_scale_lin_daily_True_T_56
        File bayesian_results_vis_scale_log_daily_False_T_28
        File bayesian_results_vis_scale_log_daily_False_T_56
        File bayesian_results_vis_scale_log_daily_True_T_28
        File bayesian_results_vis_scale_log_daily_True_T_56
        File seir_results
    }
    command {
        ${move_results_script} "${epispot_results_txt}"
        ${move_results_script} "${epispot_results_png}"
        ${move_results_script} "${bayesian_results_samples}" "samples"
        ${move_results_script} "${bayesian_results_summary}" "summary"
        ${move_results_script} "${bayesian_results_vis_r0}" "vis"
        ${move_results_script} "${bayesian_results_vis_scale_lin_daily_False_T_28}" "vis"
        ${move_results_script} "${bayesian_results_vis_scale_lin_daily_False_T_56}" "vis"
        ${move_results_script} "${bayesian_results_vis_scale_lin_daily_True_T_28}" "vis"
        ${move_results_script} "${bayesian_results_vis_scale_lin_daily_True_T_56}" "vis"
        ${move_results_script} "${bayesian_results_vis_scale_log_daily_False_T_28}" "vis"
        ${move_results_script} "${bayesian_results_vis_scale_log_daily_False_T_56}" "vis"
        ${move_results_script} "${bayesian_results_vis_scale_log_daily_True_T_28}" "vis"
        ${move_results_script} "${bayesian_results_vis_scale_log_daily_True_T_56}" "vis"
        ${move_results_script} "${seir_results}"
    }
    output {
        String out = read_string(stdout())
    }
}

workflow idmWorkflow {
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

    call run_bayesian {
        input:
            setup_os_script = "./scripts/sh/setup_os.sh",
            install_git_script = "./scripts/sh/install_git.sh",
            install_python_script = "./scripts/sh/bayesian/install_python_libraries.sh",
            install_model_script = "./scripts/sh/bayesian/install_model.sh",
            run_model_script = "./scripts/sh/bayesian/run_model.sh",
            git_repository_url = "https://github.com/midas-network/bayesian-covid-model-demo.git",
            state = "GA",
            start_date = "2020-03-05",
            end_date = "2020-03-07"
    }

    call run_seir {
        input:
            setup_os_script = "./scripts/sh/setup_os.sh",
            install_SEIR_script = "./scripts/sh/seir/install_SEIR.sh",
            SEIR_script = "./scripts/R/seir/SEIR.R",
    }

    output {
#        File epispot_response = run_epispot.response
        File epispot_results_txt = run_epispot.epispot_results_txt
        File epispot_results_png = run_epispot.epispot_results_png

#        File response = run_bayesian.response
        File bayesian_results_samples = run_bayesian.results_samples
        File bayesian_results_summary = run_bayesian.results_summary
        File bayesian_results_vis_r0 = run_bayesian.results_vis_r0
        File bayesian_results_vis_scale_lin_daily_False_T_28 = run_bayesian.results_vis_scale_lin_daily_False_T_28
        File bayesian_results_vis_scale_lin_daily_False_T_56 = run_bayesian.results_vis_scale_lin_daily_False_T_56
        File bayesian_results_vis_scale_lin_daily_True_T_28 = run_bayesian.results_vis_scale_lin_daily_True_T_28
        File bayesian_results_vis_scale_lin_daily_True_T_56 = run_bayesian.results_vis_scale_lin_daily_True_T_56
        File bayesian_results_vis_scale_log_daily_False_T_28 = run_bayesian.results_vis_scale_log_daily_False_T_28
        File bayesian_results_vis_scale_log_daily_False_T_56 = run_bayesian.results_vis_scale_log_daily_False_T_56
        File bayesian_results_vis_scale_log_daily_True_T_28 = run_bayesian.results_vis_scale_log_daily_True_T_28
        File bayesian_results_vis_scale_log_daily_True_T_56 = run_bayesian.results_vis_scale_log_daily_True_T_56

#        File seir_response = run_seir.response
        File seir_results = run_seir.seir_results
    }


    call moveResults {
        input: 
            move_results_script = "./scripts/sh/move_results.sh",
#            epispot_response = epispot_response,
            epispot_results_txt = epispot_results_txt,
            epispot_results_png = epispot_results_png,
#            bayesian_response = bayesian_response,
            bayesian_results_samples = bayesian_results_samples,
            bayesian_results_summary = bayesian_results_summary,
            bayesian_results_vis_r0 = bayesian_results_vis_r0,
            bayesian_results_vis_scale_lin_daily_False_T_28 = bayesian_results_vis_scale_lin_daily_False_T_28,
            bayesian_results_vis_scale_lin_daily_False_T_56 = bayesian_results_vis_scale_lin_daily_False_T_56,
            bayesian_results_vis_scale_lin_daily_True_T_28 = bayesian_results_vis_scale_lin_daily_True_T_28,
            bayesian_results_vis_scale_lin_daily_True_T_56 = bayesian_results_vis_scale_lin_daily_True_T_56,
            bayesian_results_vis_scale_log_daily_False_T_28 = bayesian_results_vis_scale_log_daily_False_T_28,
            bayesian_results_vis_scale_log_daily_False_T_56 = bayesian_results_vis_scale_log_daily_False_T_56,
            bayesian_results_vis_scale_log_daily_True_T_28 = bayesian_results_vis_scale_log_daily_True_T_28,
            bayesian_results_vis_scale_log_daily_True_T_56 = bayesian_results_vis_scale_log_daily_True_T_56,
#            seir_response = seir_response,
            seir_results = seir_results
    }

}

