version 1.0

import "model_inputs.wdl" as modelInputs
import "epispot.wdl" as epispot
import "bayesian.wdl" as bayesian
import "seir.wdl" as seir

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

# https://cromwell.readthedocs.io/en/stable/SubWorkflows/
# A sub-workflows is executed exactly as a task would be. This means that if another call depends on an output of a sub-workflow, this call will run when the whole sub-workflow completes (successfully).

workflow idmWorkflow {
    call modelInputs.modelInputsWorkflow {}
    call epispot.epispotWorkflow {
        input:
            parameters = modelInputsWorkflow.epispot
    }
    call bayesian.bayesianWorkflow {
        input:
            bayesian_parameters = modelInputsWorkflow.bayesian
    }
    call seir.seirWorkflow {}

    output {
#        File epispot_response = epispotWorkflow.response
        File epispot_results_txt = epispotWorkflow.results_txt
        File epispot_results_png = epispotWorkflow.results_png
#        File bayesian_response = bayesianWorkflow.response
        File bayesian_results_samples = bayesianWorkflow.bayesian_results_samples
        File bayesian_results_summary = bayesianWorkflow.bayesian_results_summary
        File bayesian_results_vis_r0 = bayesianWorkflow.bayesian_results_vis_r0
        File bayesian_results_vis_scale_lin_daily_False_T_28 = bayesianWorkflow.bayesian_results_vis_scale_lin_daily_False_T_28
        File bayesian_results_vis_scale_lin_daily_False_T_56 = bayesianWorkflow.bayesian_results_vis_scale_lin_daily_False_T_56
        File bayesian_results_vis_scale_lin_daily_True_T_28 = bayesianWorkflow.bayesian_results_vis_scale_lin_daily_True_T_28
        File bayesian_results_vis_scale_lin_daily_True_T_56 = bayesianWorkflow.bayesian_results_vis_scale_lin_daily_True_T_56
        File bayesian_results_vis_scale_log_daily_False_T_28 = bayesianWorkflow.bayesian_results_vis_scale_log_daily_False_T_28
        File bayesian_results_vis_scale_log_daily_False_T_56 = bayesianWorkflow.bayesian_results_vis_scale_log_daily_False_T_56
        File bayesian_results_vis_scale_log_daily_True_T_28 = bayesianWorkflow.bayesian_results_vis_scale_log_daily_True_T_28
        File bayesian_results_vis_scale_log_daily_True_T_56 = bayesianWorkflow.bayesian_results_vis_scale_log_daily_True_T_56
#        File seir_response = seirWorkflow.response
        File seir_results = seirWorkflow.results

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

