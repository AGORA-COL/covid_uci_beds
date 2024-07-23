# COVID Variant Dominance Model Explanation

This document provides a detailed explanation of the mathematical model used for fitting the dominance data of each COVID variant. The core of this model is encapsulated in the `ModelFunc` class, which utilizes a specific function inspired by the derivative of the sigmoid function.

## Mathematical Model

The function used to model the dominance of COVID variants over time is defined as:

$$ D_i(x) = \frac{q_i(x)}{\sum_i{q_i(x)}}$$

with $q_i(x)$ defined as:
$$q_i(x) = \left( \frac{1}{1 + e^{-(a_i x + b_i)}} \right) \times \left( 1 - \frac{1}{1 + e^{-(c_i x + d_i)}} \right)$$


Where:
- $x$ represents the days since the start date.
- $a_i, b_i, c_i, d_i$ are parameters of the variant $i$ to be estimated through the fitting process and modulate the shape of the curve, influencing its growth rate, inflection points, and saturation levels.

## Inspiration from the Sigmoid Function

The model is inspired by the derivative of the sigmoid function, which is known for its S-shaped curve. The sigmoid function, denoted as $\sigma(x)$, is commonly used in logistic regression and neural networks to model probabilities and binary outcomes. Its derivative represents the rate of change of the curve, which is useful for modeling growth processes that undergo acceleration and deceleration phases.

The use of two sigmoid components in the function allows for modeling the dynamics of COVID variant dominance with flexibility. The first component, $\frac{1}{1 + e^{-(a x + b)}}$, models the initial growth phase of the variant, while the second component, $1 - \frac{1}{1 + e^{-(c x + d)}}$, accounts for the eventual decline or saturation in dominance as other factors or variants come into play.

## Objective

The primary objective of this mathematical model is to fit the dominance data of each COVID variant accurately. By adjusting the parameters $a, b, c, d$, the model can be tailored to reflect the unique growth and decline patterns of different variants over time. The fitting process involves minimizing the mean squared error between the model's predictions and the actual data, ensuring an optimal representation of the dominance trends.

# Parameter Estimation for Departments with Low Data Availability

## Trajectories Defined

To address the challenge of estimating parameters for Colombian departments with a low number of GISAID samples, we define specific "Trajectories". Each trajectory groups departments based on geographical proximity with the first department in each trajectory having reliable statistical data. The trajectories are as follows:

- **Traj_1**: 'BOGOTÁ D.C.', 'TOLIMA', 'HUILA', etc.
- **Traj_2**: 'ANTIOQUIA', 'VALLE DEL CAUCA', 'QUINDIO', etc.
- **Traj_3**: 'BOGOTÁ D.C.', 'CUNDINAMARCA', 'BOYACÁ', etc.
- **Traj_4**: 'ANTIOQUIA', 'CHOCÓ', 'CÓRDOBA', 'SUCRE', 'BOLÍVAR'
- **Traj_5**: 'SANTANDER', 'NORTE DE SANTANDER', 'CESAR', 'MAGDALENA', 'ATLANTICO', 'LA GUAJIRA'
- **Traj_6**: 'BOLÍVAR', 'SAN ANDRÉS, PROVIDENCIA Y SANTA CATALINA'

The concept behind this approach is to use the adjusted parameters from the initial departments as a starting point for estimating parameters for other departments within the same trajectory. This method assumes that departments within the same trajectory will have similar epidemic dynamics and therefore, similar parameter values, albeit adjusted for their specific data.

## Implementation Strategy

The process involves several steps outlined in the provided code snippet:

1. **Initialization**: For each trajectory, identify the initial department with reliable data and load its fitted parameters as the starting point for parameter estimation.
2. **Parameter Adjustment**: For subsequent departments in the trajectory, adjust the parameters based on available data, starting from the initial parameters of the first department in the trajectory.
3. **Gradient Descent Optimization**: Apply gradient descent optimization to refine the parameters for each variant within the target department, leveraging the initial guess from the previous department's fitted parameters.
4. **Handling Missing Variants**: For variants not present in the target department's data, use the parameters from the initial department directly.
5. **Iteration**: After fitting parameters for one department, its optimized parameters become the starting point for the next department in the trajectory.

This strategy ensures a more informed and potentially accurate parameter estimation process for departments with limited data by leveraging the similarities in epidemic dynamics within defined trajectories. The increased learning rate for departments later in the trajectory sequence (`lr=(1+3*n_)*0.001`) accounts for the need to adjust more aggressively based on the specific data of each department.