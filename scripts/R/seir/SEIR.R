# Load libraries
library(deSolve)
library(ggplot2)

# Define parameters
pop_size <- 1000000
incubation_period <- 17
beta <- 0.4
gamma <- 0.1

# Define SEIR model function
seir_model <- function(time, state, parameters) {
    with(as.list(c(state, parameters)), {
        # Calculate rates of change
        dS <- -beta * S * I / pop_size
        dE <- beta * S * I / pop_size - incubation_period^-1 * E
        dI <- incubation_period^-1 * E - gamma * I
        dR <- gamma * I
        # Return rates of change
        list(c(dS, dE, dI, dR))
    })
}

# Set initial conditions
state0 <- c(S = pop_size - 1, E = 1, I = 0, R = 0)

# Create time points
times <- seq(0, 365, by = 1)

# Solve model
model_output <- ode(y = state0, times = times, func = seir_model,
                    parms = c(beta = beta, gamma = gamma))

# Convert to data frame
model_output <- as.data.frame(model_output)

# Plot results
ggplot(model_output, aes(x = time)) +
    geom_line(aes(y = S, color = "Susceptible")) +
    geom_line(aes(y = E, color = "Exposed")) +
    geom_line(aes(y = I, color = "Infectious")) +
    geom_line(aes(y = R, color = "Recovered")) +
    labs(title = "SEIR Model", x = "Time (days)", y = "Number of people") +
    scale_color_manual(values = c("Susceptible" = "blue",
                                  "Exposed" = "orange",
                                  "Infectious" = "red",
                                  "Recovered" = "green"))