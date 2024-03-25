version 1.0

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

workflow seirWorkflow {
    call run_seir {
        input:
            setup_os_script = "./scripts/sh/setup_os.sh",
            install_SEIR_script = "./scripts/sh/seir/install_SEIR.sh",
            SEIR_script = "./scripts/R/seir/SEIR.R",
    }

    output {
#        File response = run_seir.response
        File results = run_seir.seir_results
    }
}

