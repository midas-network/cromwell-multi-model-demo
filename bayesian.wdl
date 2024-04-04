version 1.0

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

workflow bayesianWorkflow {
    input {
        Map[String, String] bayesian_parameters
    }
    call run_bayesian {
        input:
            setup_os_script = "./scripts/sh/setup_os.sh",
            install_git_script = "./scripts/sh/install_git.sh",
            install_python_script = "./scripts/sh/bayesian/install_python_libraries.sh",
            install_model_script = "./scripts/sh/bayesian/install_model.sh",
            run_model_script = "./scripts/sh/bayesian/run_model.sh",
            git_repository_url = "https://github.com/midas-network/bayesian-covid-model-demo.git",
            state = bayesian_parameters["state"],
            start_date = bayesian_parameters["start_date"],
            end_date = bayesian_parameters["end_date"]
    }

    output {
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
    }
}

