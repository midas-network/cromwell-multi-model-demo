version 1.0

struct ModelInputs {
	String model
	Map[String, String] parameters
}

workflow modelInputsWorkflow {
    input {
        File jsonFile = "model_input_parameters.json"
    }

	Array[ModelInputs] modelInputs = read_json(jsonFile)
	scatter (modelInput in modelInputs){
		String modelName = modelInput.model
		if (modelName=="epispot") {
			Map[String, String] epispotMap = modelInput.parameters 
		}
		if (modelName=="bayesian") {
			Map[String, String] bayesianMap = modelInput.parameters 
		}
	}

	output {
		Map[String, String] epispot = select_first(epispotMap)
		Map[String, String] bayesian = select_first(bayesianMap)
	}
}
