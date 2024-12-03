import os
import numpy as np
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import streamlit as st
from scipy.optimize import curve_fit
from scipy.integrate import solve_ivp
from scipy.stats import t
import sympy as sp
from scipy.optimize import minimize
import uuid
from PIL import Image
import ruptures as rpt

def detect_phases(time, od_values, model="l2", pen=10):
    """
    Detect phases in the OD values using change point detection.

    Parameters:
    - time (array-like): Array of time points.
    - od_values (array-like): Array of OD measurements.
    - model (str): Cost function to use for change point detection.
    - pen (float): Penalty value to control the number of change points.

    Returns:
    - phases (list of tuples): List containing (start_time, end_time) for each detected phase.
    - breakpoints (list): Indices of detected change points.
    """
    # Reshape the data for ruptures
    signal = od_values.reshape(-1, 1)

    # Initialize the change point detection algorithm
    algo = rpt.Pelt(model=model).fit(signal)
    
    # Detect change points with the specified penalty
    breakpoints = algo.predict(pen=pen)
    
    # Convert breakpoints to phase intervals
    phases = []
    start_idx = 0
    for bp in breakpoints:
        end_idx = bp
        phases.append((time[start_idx], time[end_idx - 1]))
        start_idx = bp
    
    return phases, breakpoints

def plot_detected_phases(time, od_values, phases):
    """
    Plot the OD values with detected phases highlighted.

    Parameters:
    - time (array-like): Array of time points.
    - od_values (array-like): Array of OD measurements.
    - phases (list of tuples): List containing (start_time, end_time) for each detected phase.
    """
    fig = go.Figure()
    
    # Plot the average OD curve
    fig.add_trace(go.Scatter(
        x=time,
        y=od_values,
        mode='lines+markers',
        name='Average OD',
        line=dict(color='blue')
    ))
    
    # Highlight each phase
    colors = ['rgba(255, 0, 0, 0.2)', 'rgba(0, 255, 0, 0.2)', 'rgba(0, 0, 255, 0.2)', 'rgba(255, 255, 0, 0.2)']
    for idx, (start, end) in enumerate(phases):
        color = colors[idx % len(colors)]
        fig.add_vrect(
            x0=start,
            x1=end,
            fillcolor=color,
            opacity=0.3,
            layer="below",
            line_width=0,
            annotation_text=f"Phase {idx + 1}",
            annotation_position="top left"
        )
    
    fig.update_layout(
        title='Automatic Phase Detection',
        xaxis_title='Time',
        yaxis_title='OD',
        template='plotly_white'
    )
    
    st.plotly_chart(fig, use_container_width=True)


#display ode equations
def display_ode_equations(variables, odes):
    """
    Generate and display ODE equations in LaTeX format.

    Parameters:
    - variables (list): List of variable names.
    - odes (list): List of ODE expressions.
    """
    st.write("### ODE Equations")
    for var, ode in zip(variables, odes):
        try:
            # Use SymPy to parse the ODE expression and convert to LaTeX
            ode_expr = sp.sympify(ode)
            equation = f"\\frac{{d{var}}}{{dt}} = {sp.latex(ode_expr)}"
            st.latex(equation)
        except Exception as e:
            st.error(f"Error displaying equation for variable '{var}': {e}")
#ode fitting
def parse_ode(ode_expr, variables, parameters):
    """
    Parse the ODE expression into a callable function.
    Example: "r * X" becomes a function that computes r * X.
    """
    try:
        # Define symbols
        t_sym, *var_syms = sp.symbols(['t'] + variables)
        param_syms = sp.symbols(parameters)
        
        # Create a dictionary for sympy
        local_dict = {var: var_sym for var, var_sym in zip(variables, var_syms)}
        local_dict.update({param: param_sym for param, param_sym in zip(parameters, param_syms)})
        local_dict['t'] = t_sym
        
        # Parse the expression
        expr = sp.sympify(ode_expr, locals=local_dict)
        
        # Convert to a lambda function
        func = sp.lambdify((t_sym, var_syms, param_syms), expr, 'numpy')
        
        # Return a function that matches the required signature for ODE solvers
        def ode_func(t, y, params):
            return func(t, y, params)
        
        return ode_func
    except Exception as e:
        st.error(f"Error parsing ODE expression '{ode_expr}': {e}")
        return None

def solve_custom_ode(ode_funcs, y0, params, t_span, t_eval, variables, observed_data=None):
    """
    Solve a system of custom ODEs with an option to dynamically adjust initial conditions.

    Parameters:
    - ode_funcs (list): List of callable ODE functions.
    - y0 (list): Initial conditions for the variables.
    - params (list): Parameters for the ODEs.
    - t_span (tuple): Time span for the solution.
    - t_eval (array): Time points at which to store the solution.
    - variables (list): List of variable names.
    - observed_data (dict): A dictionary containing variable names as keys and observed data arrays as values.
                            The initial condition of the first variable will be adjusted to the starting value
                            of its observed data within the time range.

    Returns:
    - sol (OdeResult): The solution object from solve_ivp.
    """
    def system(t, y):
        dydt = []
        for idx, func in enumerate(ode_funcs):
            try:
                dydt_value = func(t, y, params)
                dydt.append(dydt_value)
            except Exception as e:
                st.error(f"Error evaluating ODE for variable '{variables[idx]}' at time {t:.2f}: {e}")
                raise
        return dydt

    try:
        # Adjust initial condition of the first variable based on observed data
        if observed_data is not None and len(y0) > 0 and variables[0] in observed_data:
            observed_values = observed_data[variables[0]]
            observed_time = observed_data["Time"]
            mask = (observed_time >= t_span[0]) & (observed_time <= t_span[1])
            if mask.any():
                y0[0] = observed_values[mask].iloc[0]  # Dynamically set initial condition for the first variable

        # Solve the system of ODEs
        sol = solve_ivp(system, t_span, y0, t_eval=t_eval, method='RK45')
        if not sol.success:
            st.error(f"ODE Solver failed: {sol.message}")
            return None
        return sol
    except Exception as e:
        st.error(f"Error solving ODEs: {e}")
        return None

def plot_ode_solution(sol, variables, title="ODE Solutions"):
    """
    Plot the ODE solutions using Plotly.

    Parameters:
    - sol (OdeResult): The solution object from solve_ivp.
    - variables (list): List of variable names.
    - title (str): Title of the plot.

    Returns:
    - fig (Plotly Figure): The generated plot.
    """
    fig = go.Figure()
    for idx, var in enumerate(variables):
        fig.add_trace(go.Scatter(
            x=sol.t,
            y=sol.y[idx],
            mode='lines',
            name=var
        ))
    fig.update_layout(
        title=title,
        xaxis_title='Time',
        yaxis_title='Concentration',
        template='plotly_white'
    )
    return fig

def validate_phase_inputs(variables, parameters, odes):
    """Validate the inputs for the ODE phase."""
    if not variables:
        st.error("At least one variable is required.")
        return False
    if not parameters:
        st.error("At least one parameter is required.")
        return False
    if len(odes) != len(variables):
        st.error("Number of ODE expressions must match number of variables.")
        return False
    if any(not ode.strip() for ode in odes):
        st.error("All ODE expressions must be non-empty.")
        return False
    return True

from scipy.optimize import approx_fprime
from scipy.stats import t

def compute_ode_confidence_intervals(sol, params, pcov, alpha=0.05):
    """
    Compute confidence intervals for the ODE solution.

    Parameters:
    - sol: OdeResult from solve_ivp (solution object).
    - params: Optimized parameters.
    - pcov: Covariance matrix of the fitted parameters.
    - alpha: Significance level (default is 0.05 for 95% CI).

    Returns:
    - lower_bound, upper_bound: Confidence interval bounds for each variable in the solution.
    """
    t_critical = t.ppf(1 - alpha / 2, len(sol.t) - len(params))
    epsilon = np.sqrt(np.finfo(float).eps)  # Small value for numerical approximation

    conf_intervals = []
    for var_idx in range(sol.y.shape[0]):  # Loop through variables
        lower_bound = []
        upper_bound = []
        for t_idx, t_val in enumerate(sol.t):
            def func(p):
                # Solve ODE at a single time point with perturbed parameters
                perturbed_sol = solve_ivp(
                    lambda t, y: system(t, y, p),
                    [t_val, t_val + epsilon],
                    sol.y[:, t_idx],
                    method='RK45',
                )
                return perturbed_sol.y[var_idx, -1]

            # Approximate the gradient for the current time step
            gradient = approx_fprime(params, func, epsilon)

            # Compute variance at this time point
            variance = np.dot(gradient, np.dot(pcov, gradient.T))

            # Compute bounds
            std_error = np.sqrt(variance)
            ci = t_critical * std_error
            lower_bound.append(sol.y[var_idx, t_idx] - ci)
            upper_bound.append(sol.y[var_idx, t_idx] + ci)

        conf_intervals.append((lower_bound, upper_bound))
    return conf_intervals

#D efine growth models
def polynomial_growth(x, a, n, b):
    return a * np.power(x, n) + b


def polynomial_func(t, a, b, c):
    return a * t**2 + b * t + c


def exponential_growth(t, mu, X0):
    return X0 * np.exp(mu * t)


def logistic_growth(t, mu, X0, K):
    return (X0 * np.exp(mu * t)) / (1 + (X0 / K) * (np.exp(mu * t) - 1))


def baranyi_growth(t, X0, mu, q0):
    q_t = q0 * np.exp(mu * t)
    return X0 * (1 + q_t) / (1 + q0)


def lag_exponential_saturation_growth(t, mu, X0, q0, K):
    return X0 * (1 + q0 * np.exp(mu * t)) / (1 + q0 - q0 * (X0 / K) + (q0 * X0 / K) * np.exp(mu * t))


# Function to calculate model metrics
def calculate_metrics(observed, predicted, num_params):
    residuals = observed - predicted
    rss = np.sum(residuals**2)
    r_squared = 1 - (rss / np.sum((observed - np.mean(observed))**2))
    aic = 2 * num_params + len(observed) * np.log(rss / len(observed))
    return rss, r_squared, aic


# Compute normal confidence intervals
from scipy.optimize import approx_fprime
from scipy.stats import t
import numpy as np

from scipy.optimize import approx_fprime
from scipy.stats import t
import numpy as np

def compute_confidence_intervals(time, params, covariance, alpha, dof, residual_variance, model_func):
    """
    Compute confidence intervals for fitted data.

    Parameters:
    - time: Array of time values.
    - params: Fitted model parameters.
    - covariance: Covariance matrix of the fitted parameters.
    - alpha: Significance level for confidence intervals (e.g., 0.05 for 95% CI).
    - dof: Degrees of freedom for the fit.
    - residual_variance: Variance of the residuals.
    - model_func: The growth model function.

    Returns:
    - lower_bound: Lower confidence interval values.
    - upper_bound: Upper confidence interval values.
    """
    t_critical = t.ppf(1 - alpha / 2, dof)
    epsilon = np.sqrt(np.finfo(float).eps)  # Small value for numerical approximation
    conf_interval = np.zeros(len(time))
    fitted_values = model_func(time, *params)

    for i in range(len(time)):
        def func(p):
            return model_func(np.array([time[i]]), *p)

        # Approximate gradient (Jacobian row)
        gradient = approx_fprime(params, func, epsilon)

        # Confidence interval computation
        conf_interval[i] = np.sqrt(np.dot(gradient, np.dot(covariance, gradient.T)) + residual_variance)

    lower_bound = fitted_values - t_critical * conf_interval
    upper_bound = fitted_values + t_critical * conf_interval

    return lower_bound, upper_bound



# Select layout for wells
def select_layout():
    layout_option = st.selectbox("Select layout option", ["Select from presets", "Custom"])
    if layout_option == "Select from presets":
        well_format = st.selectbox("Select well format", ["24 well rows 4 column 6", "96 well rows 8 column 12",
                                                         "84 well rows 7 column 12", "1536 well rows 32 column 48"])
        if well_format == "24 well rows 4 column 6":
            return 4, 6
        elif well_format == "96 well rows 8 column 12":
            return 8, 12
        elif well_format == "84 well rows 7 column 12":
            return 7, 12
        elif well_format == "1536 well rows 32 column 48":
            return 32, 48
    else:
        custom_rows = st.number_input("Enter number of rows", min_value=1, step=1)
        custom_columns = st.number_input("Enter number of columns", min_value=1, step=1)
        return int(custom_rows), int(custom_columns)

# Perform operations between two groups' background-subtracted data
# Function to perform operations on background-subtracted data between two groups
# Perform operations on background-subtracted data between two groups with dynamic labeling
def perform_group_operations(group1_data, group2_data, operation):
    # Initialize a new DataFrame to store the operated results
    operated_data = pd.DataFrame({"Time": group1_data["Time"]})
    
    # Get the sample wells for each group
    sample_wells1 = list(group1_data.columns[1:])  # Exclude "Time" column
    sample_wells2 = list(group2_data.columns[1:])
    
    # Ensure equal length of sample wells for pairing
    min_len = min(len(sample_wells1), len(sample_wells2))
    sample_wells1 = sample_wells1[:min_len]
    sample_wells2 = sample_wells2[:min_len]

    # Define the symbol to use for each operation
    symbol_map = {
        "Add": "+",
        "Subtract": "-",
        "Multiply": "*",
        "Divide": "/"
    }
    symbol = symbol_map.get(operation, "+")  # Default to "+" if operation is unknown

    # Perform the operation on each pair of sample wells and set dynamic labels
    for well1, well2 in zip(sample_wells1, sample_wells2):
        new_label = f"{well1} {symbol} {well2}"  # Create a dynamic label based on operation
        if operation == "Add":
            operated_data[new_label] = group1_data[well1] + group2_data[well2]
        elif operation == "Subtract":
            operated_data[new_label] = group1_data[well1] - group2_data[well2]
        elif operation == "Multiply":
            operated_data[new_label] = group1_data[well1] * group2_data[well2]
        elif operation == "Divide":
            operated_data[new_label] = group1_data[well1] / group2_data[well2].replace(0, np.nan)  # Avoid divide-by-zero
    
    return operated_data


# Plot fitted curves with Plotly
def plot_fitted_curves(df, time, observed, fitted, model_name):
    fig = go.Figure()
    fig.add_trace(go.Scatter(x=time, y=observed, mode='lines', name='Observed Data'))
    fig.add_trace(go.Scatter(x=time, y=fitted, mode='lines', name=f'Fitted Curve ({model_name})', line=dict(color='red')))
    fig.update_layout(title=f'Fitted {model_name} Model', xaxis_title='Time', yaxis_title='OD', legend_title='Legend', template='plotly_white')
    st.plotly_chart(fig)

# Upload file
def upload_file():
    uploaded_file = st.file_uploader("Choose a file", type=["xlsx", "csv"])
    return uploaded_file


# Read data
@st.cache_data
def read_data(uploaded_file, rows, columns):
    if uploaded_file is not None:
        try:
            st.success("File uploaded successfully!")
            if uploaded_file.name.endswith('.xlsx'):
                df = pd.read_excel(uploaded_file, header=None)
            elif uploaded_file.name.endswith('.csv'):
                df = pd.read_csv(uploaded_file, header=None)
            df = adjust_dataframe_layout(df, rows, columns)
            return df
        except Exception as e:
            st.error(f"Error: {e}")
    return None


# Adjust DataFrame layout to match specified rows and columns
def adjust_dataframe_layout(df, rows, columns):
    total_columns = rows * columns
    labels = generate_labels(rows, columns)
    
    if df.shape[1] < total_columns + 1:
        extra_cols = pd.DataFrame(np.nan, index=df.index, columns=range(df.shape[1], total_columns + 1))
        df = pd.concat([df, extra_cols], axis=1)
    
    df = df.iloc[:, :total_columns + 1]
    df.columns = ["Time"] + labels
    return df


# Generate labels for well selection
def generate_labels(rows, cols):
    labels = []
    for i in range(rows):
        for j in range(cols):
            label = chr(ord('A') + i) + str(j + 1)
            labels.append(label)
    return labels


# Create a button layout for selecting wells using generated labels and display selected wells
def create_button_layout(rows, columns, labels, key_prefix):
    # Initialize session state for the selected wells if not already set
    if f"{key_prefix}_selected_wells" not in st.session_state:
        st.session_state[f"{key_prefix}_selected_wells"] = []  # Use a list instead of a set

    # Layout the buttons and manage selections
    index = 0
    with st.container():
        for i in range(rows):
            cols_ui = st.columns(columns)
            for j in range(columns):
                well_name = labels[index]
                # Create a unique key for each button based on the key_prefix
                if cols_ui[j].button(well_name, key=f"{key_prefix}_{well_name}"):
                    # Toggle selection status of the well
                    if well_name in st.session_state[f"{key_prefix}_selected_wells"]:
                        st.session_state[f"{key_prefix}_selected_wells"].remove(well_name)
                    else:
                        st.session_state[f"{key_prefix}_selected_wells"].append(well_name)
                index += 1

    # Display the currently selected wells in the order of the labels
    selected_wells = [well for well in labels if well in st.session_state[f"{key_prefix}_selected_wells"]]

    # Make the display fancy using HTML and CSS
    if selected_wells:
        wells_str = ''
        for well in selected_wells:
            wells_str += f'''
            <span style="
                background-color:#007ACC;
                color:#FFFFFF;
                padding:5px 10px;
                border-radius:5px;
                margin-right:5px;
                display:inline-block;
                font-weight:bold;
            ">{well}</span>'''
        st.markdown(f"### Selected Wells for **{key_prefix}**:", unsafe_allow_html=True)
        st.markdown(wells_str, unsafe_allow_html=True)
    else:
        st.info(f"No wells selected for **{key_prefix}**.")

    return selected_wells


# Perform background subtraction for each group with selected blank and sample wells
def perform_background_subtraction(groups_data, df, group_num, selected_blank_wells, selected_sample_wells):
    if len(selected_blank_wells) == 0 or len(selected_sample_wells) == 0:
        st.warning(f"Please select both blank wells and sample wells for Group {group_num} for background subtraction.")
        return None

    # Calculate the mean of blank wells for background subtraction
    blank_mean = df[selected_blank_wells].mean(axis=1)

    # Create a copy of the original data for this group and perform the background subtraction
    group_df = df.copy()
    for sample_well in selected_sample_wells:
        # Subtract the blank mean and set negative values to 0
        group_df[sample_well] = (df[sample_well] - blank_mean).clip(lower=0)

    # Store the background-subtracted data and sample wells for this group
    groups_data[f"Group_{group_num}_bg_subtracted"] = group_df
    groups_data[f"Group_{group_num}_sample_wells"] = selected_sample_wells  # Store selected sample wells for this group
    return groups_data

import plotly.graph_objects as go

import numpy as np

def plot_phase_fit_with_ci(phase_fits, operated_data, selected_operated_wells):
    """
    Plot all phase fits with their confidence intervals and standard deviations on a single Plotly figure.

    Parameters:
    - phase_fits: List of dictionaries containing phase fit data.
    - operated_data: DataFrame containing the operated data.
    - selected_operated_wells: List of selected wells for plotting.

    Returns:
    - Plotly Figure.
    """
    fig = go.Figure()

    # Always calculate the average over the selected operated wells
    average_values = operated_data[selected_operated_wells].mean(axis=1)

    # Plot the overall average data
    fig.add_trace(go.Scatter(
        x=operated_data["Time"],
        y=average_values,
        mode='lines',
        name='Average Data',
        line=dict(color='black', width=2)
    ))

    # Plot each phase fit
    for fit in phase_fits:
        phase_num = fit['phase']
        model_name = fit['model']
        phase_time = fit['phase_time']
        y_pred = fit['fit']
        lower = fit['lower_bound']
        upper = fit['upper_bound']
        std_dev = fit['std_dev']

        # Confidence Interval
        fig.add_trace(go.Scatter(
            x=np.concatenate([phase_time, phase_time[::-1]]),
            y=np.concatenate([lower, upper[::-1]]),
            fill='toself',
            fillcolor='rgba(173, 216, 230, 0.4)',
            line=dict(color='rgba(255, 255, 255, 0)'),
            hoverinfo="skip",
            name=f'Phase {phase_num} 95% CI',
            showlegend=False
        ))

        # Fitted Data
        fig.add_trace(go.Scatter(
            x=phase_time,
            y=y_pred,
            mode='lines',
            name=f'Phase {phase_num} Fit ({model_name})',
            line=dict(width=2)
        ))

        # Standard Deviation Bands
        upper_sd = (y_pred + std_dev).tolist()
        lower_sd = (y_pred - std_dev).tolist()
        fig.add_trace(go.Scatter(
            x=phase_time.tolist() + phase_time.tolist()[::-1],
            y=upper_sd + lower_sd[::-1],
            fill='toself',
            fillcolor='rgba(144, 238, 144, 0.3)',
            line=dict(color='rgba(255, 255, 255, 0)'),
            hoverinfo="skip",
            name=f'Phase {phase_num} Std Dev',
            showlegend=False
        ))

    fig.update_layout(
        title='All Phase Fits with Confidence Intervals and Standard Deviations',
        xaxis_title='Time',
        yaxis_title='OD',
        legend_title='Legend',
        template='plotly_white'
    )

    return fig


# Compute confidence intervals on the blank well fit
def compute_confidence_intervals(time, params, covariance, alpha, dof, residual_variance, model_func):
    """
    Compute confidence intervals for fitted data.

    Parameters:
    - time: Array of time values.
    - params: Fitted model parameters.
    - covariance: Covariance matrix of the fitted parameters.
    - alpha: Significance level for confidence intervals (e.g., 0.05 for 95% CI).
    - dof: Degrees of freedom for the fit.
    - residual_variance: Variance of the residuals.
    - model_func: The growth model function.

    Returns:
    - lower_bound: Lower confidence interval values.
    - upper_bound: Upper confidence interval values.
    """
    t_critical = t.ppf(1 - alpha / 2, dof)
    epsilon = np.sqrt(np.finfo(float).eps)  # Small value for numerical approximation
    conf_interval = np.zeros(len(time))
    fitted_values = model_func(time, *params)

    for i in range(len(time)):
        # Approximate gradient (Jacobian row)
        gradient = approx_fprime(params, lambda p: model_func(time[i], *p), epsilon)

        # Confidence interval computation
        conf_interval[i] = np.sqrt(np.dot(gradient, np.dot(covariance, gradient.T)) + residual_variance)

    lower_bound = fitted_values - t_critical * conf_interval
    upper_bound = fitted_values + t_critical * conf_interval

    return lower_bound, upper_bound


def display_single_well_preview(df, well_name):
    """
    Display a small preview plot for a selected well.

    Parameters:
    - df: DataFrame containing well data.
    - well_name: The name of the well to display.
    """
    if well_name and well_name in df.columns:
        fig = go.Figure()
        fig.add_trace(go.Scatter(x=df['Time'], y=df[well_name], mode='lines', name=f'{well_name}'))
        
        # Customize the layout for a smaller preview plot
        fig.update_layout(
            title=f'Preview of {well_name}',
            xaxis_title='Time',
            yaxis_title='OD',
            template='plotly_white',
            width=400,  # Adjust width
            height=300,  # Adjust height
            showlegend=False
        )
        st.plotly_chart(fig)
    else:
        st.write("No well selected for preview.")

        
# Plot confidence intervals and SD with Plotly for blank well fit
def plot_confidence_intervals(df, lower_bound, upper_bound, y_pred, std_dev):
    fig = go.Figure()

    fig.add_trace(go.Scatter(
        x=np.concatenate([df['Time'], df['Time'][::-1]]),
        y=np.concatenate([lower_bound, upper_bound[::-1]]),
        fill='toself',
        fillcolor='rgba(173, 216, 230, 0.4)',
        line=dict(color='rgba(255, 255, 255, 0)'),
        hoverinfo="skip",
        showlegend=True,
        name='95% Confidence Interval'
    ))

    fig.add_trace(go.Scatter(
        x=df['Time'],
        y=df['Average'],
        mode='lines',
        name='Observed Data',
        line=dict(color='royalblue')
    ))

    fig.add_trace(go.Scatter(
        x=df['Time'].tolist() + df['Time'].tolist()[::-1],
        y=(df['Average'] - std_dev).tolist() + (df['Average'] + std_dev).tolist()[::-1],
        fill='toself',
        fillcolor='rgba(144, 238, 144, 0.3)',
        line=dict(color='rgba(255, 255, 255, 0)'),
        hoverinfo="skip",
        showlegend=True,
        name='Standard Deviation'
    ))

    fig.add_trace(go.Scatter(
        x=df['Time'],
        y=y_pred,
        mode='lines',
        name='Fitted Curve',
        line=dict(color='crimson')
    ))

    fig.update_layout(
        title='Confidence Intervals with Standard Deviation and Fitted Curve',
        xaxis_title='Time',
        yaxis_title='OD',
        legend_title='Legend',
        template='plotly_white'
    )
    st.plotly_chart(fig)

def plot_selected_wells(df, selected_wells):
    fig = go.Figure()
    for well in selected_wells:
        fig.add_trace(go.Scatter(x=df['Time'], y=df[well], mode='lines', name=well))
    fig.update_layout(
        title="Time vs Selected Well's OD",
        xaxis_title='Time',
        yaxis_title='OD',
        legend_title='Legend',
        template='plotly_white'
    )
    
    # Generate a unique key using UUID
    unique_key = f"plot_selected_wells_{'_'.join(selected_wells)}_{uuid.uuid4().hex}"
    st.plotly_chart(fig, key=unique_key)

# Plot average of selected wells with Plotly
def plot_average(df, selected_wells):
    if len(selected_wells) > 0:
        selected_wells_list = list(selected_wells)
        df['Average'] = df[selected_wells_list].mean(axis=1)
        df['Std Dev'] = df[selected_wells_list].std(axis=1)

        fig = go.Figure()
        fig.add_trace(go.Scatter(x=df['Time'], y=df['Average'], mode='lines', name='Average Measurement'))

        fig.add_trace(go.Scatter(
            x=df['Time'].tolist() + df['Time'].tolist()[::-1],
            y=(df['Average'] - df['Std Dev']).tolist() + (df['Average'] + df['Std Dev']).tolist()[::-1],
            fill='toself',
            fillcolor='rgba(0, 100, 80, 0.2)',
            line=dict(color='rgba(255, 255, 255, 0)'),
            hoverinfo="skip",
            showlegend=True,
            name='Standard Deviation'
        ))

        fig.update_layout(
            title='Average Measurement for Selected Wells Over Time',
            xaxis_title='Time',
            yaxis_title='Average Measurement',
            legend_title='Legend',
            template='plotly_white'
        )

        st.plotly_chart(fig)
        return 'Average', df['Average']
    
def plot_avg_sd_bg_subtracted(group_df, sample_wells, group_num):
    """
    Plot the average and standard deviation of background-subtracted data for a specified group.

    Parameters:
    - group_df: DataFrame containing background-subtracted data.
    - sample_wells: List of sample wells selected for the group.
    - group_num: Integer representing the group number (for labeling).
    """
    if len(sample_wells) > 0:
        avg_data = group_df[sample_wells].mean(axis=1)
        std_dev = group_df[sample_wells].std(axis=1)

        fig = go.Figure()
        fig.add_trace(go.Scatter(x=group_df['Time'], y=avg_data, mode='lines', name=f'Group {group_num} Average'))

        fig.add_trace(go.Scatter(
            x=group_df['Time'].tolist() + group_df['Time'].tolist()[::-1],
            y=(avg_data - std_dev).tolist() + (avg_data + std_dev).tolist()[::-1],
            fill='toself',
            fillcolor='rgba(144, 238, 144, 0.3)',
            line=dict(color='rgba(255, 255, 255, 0)'),
            hoverinfo="skip",
            showlegend=True,
            name='Standard Deviation'
        ))

        fig.update_layout(
            title=f'Average and Standard Deviation for Background-Subtracted Data (Group {group_num})',
            xaxis_title='Time',
            yaxis_title='OD',
            legend_title='Legend',
            template='plotly_white'
        )

        # Use a unique key to prevent duplicate IDs
        unique_key = f"plot_avg_sd_bg_subtracted_group_{group_num}_{uuid.uuid4().hex}"
        st.plotly_chart(fig, key=unique_key)

def plot_avg_sd_operated(data, selected_wells):
    """
    Plot average and standard deviation of operated data.

    Parameters:
    - data: DataFrame containing operated data.
    - selected_wells: List of selected wells for plotting.
    """
    avg = data["Average"]
    sd = data[selected_wells].std(axis=1)

    fig = go.Figure()
    fig.add_trace(go.Scatter(
        x=data["Time"],
        y=avg,
        mode='lines',
        name='Average',
        line=dict(color='blue')
    ))
    fig.add_trace(go.Scatter(
        x=data["Time"],
        y=avg + sd,
        mode='lines',
        name='Average + SD',
        line=dict(color='lightblue'),
        showlegend=False
    ))
    fig.add_trace(go.Scatter(
        x=data["Time"],
        y=avg - sd,
        mode='lines',
        name='Average - SD',
        line=dict(color='lightblue'),
        fill='tonexty',
        fillcolor='rgba(173, 216, 230, 0.3)',
        showlegend=False
    ))
    fig.update_layout(
        title="Average and Standard Deviation of Operated Data",
        xaxis_title="Time",
        yaxis_title="Concentration",
        template='plotly_white'
    )

    # Generate a unique key to avoid duplicate IDs
    unique_key = f"plot_avg_sd_operated_{uuid.uuid4().hex}"
    st.plotly_chart(fig, use_container_width=True, key=unique_key)

def create_custom_model(custom_expr, param_names):
    """
    Create a callable custom model function from a user-defined expression.

    Parameters:
    - custom_expr (str): The mathematical expression as a string.
    - param_names (list): List of parameter names as strings.

    Returns:
    - func (callable): A function that takes t and individual parameters as inputs and returns the computed value.
    """
    try:
        # Define symbols
        t = sp.symbols('t')
        params = sp.symbols(param_names)
        
        # Parse the expression
        expr = sp.sympify(custom_expr)
        
        # Create a lambda function that accepts t and individual parameters
        func = sp.lambdify([t] + list(params), expr, 'numpy')
        
        return func
    except Exception as e:
        st.error(f"Error parsing custom model expression: {e}")
        return None

# Create example data dynamically (if needed)
def create_example_data():
    example_data = {
        "Time": [0, 1, 2, 3, 4],
        "A1": [0.1, 0.15, 0.2, 0.25, 0.3],
        "A2": [0.2, 0.25, 0.3, 0.35, 0.4],
        "B1": [0.3, 0.35, 0.4, 0.45, 0.5],
    }
    df = pd.DataFrame(example_data)
    df.to_excel("assets/example.xlsx", index=False)  # Save the file in the assets folder
    return df

# Update MODEL_PARAMS to include 'Custom Function'
MODEL_PARAMS = {
    "Polynomial Growth": ["a", "n", "b"],
    "Polynomial Function": ["a", "b", "c"],
    "Exponential Growth": ["mu", "X0"],
    "Logistic Growth": ["mu", "X0", "K"],
    "Baranyi Growth": ["X0", "mu", "q0"],
    "Lag-Exponential-Saturation Growth": ["mu", "X0", "q0", "K"],
    "Custom Function": []  # Parameters will be dynamically determined
}

# Update MODEL_FUNCTIONS to include a placeholder for 'Custom Function'
MODEL_FUNCTIONS = {
    "Exponential Growth": exponential_growth,
    "Logistic Growth": logistic_growth,
    "Baranyi Growth": baranyi_growth,
    "Lag-Exponential-Saturation Growth": lag_exponential_saturation_growth,
    "Custom Function": None  # Will be handled separately
}


def main():
    # Page configuration
    st.set_page_config(page_title="Bacterial Growth Analysis", page_icon="🔬", layout="wide")
    st.markdown("<h1 style='text-align: center; color: #4CAF50;'>Bacterial Growth Analysis</h1>", unsafe_allow_html=True)

    # Initialize session state variables
    if "df" not in st.session_state:
        st.session_state["df"] = None
    if "phases" not in st.session_state:
        st.session_state["phases"] = []  # Initialize an empty list for phases
    if "ode_phases" not in st.session_state:
        st.session_state["ode_phases"] = []  # Initialize an empty list for ODE phases
    if "groups_data" not in st.session_state:
        st.session_state["groups_data"] = {}
    if "selected_sample_wells_by_group" not in st.session_state:
        st.session_state["selected_sample_wells_by_group"] = {}

    
    # Step 1: Layout Selection
    rows, columns = select_layout()
    labels = generate_labels(rows, columns)
    
    # Initialize `num_groups` and `groups_data` to avoid UnboundLocalError
    num_groups = 1
    groups_data = {}
    df = None  # Initialize df to avoid reference errors

    # Use tabs to organize the main sections
    tab1, tab2, tab3, tab4, tab5, tab6, tab7 = st.tabs(["Upload Data", "Background Subtraction", "Operations", "Phase Analysis", "Custom ODE Analysis", "Automatic Phase Detection", "Growth Models"])

    # Step 2: File Upload and Data Processing
    # Tab 1: Upload Data
    with tab1:
        st.header("📁 Upload and Inspect Data")

        # Create two columns for side-by-side layout
        col1, col2 = st.columns([2, 1])  # Adjust the ratio for column widths as needed

        # Instructions in the first column
        with col1:
            st.write("""
            ### Instructions:
            1. **Upload your data file** by clicking on the **"Browse files"** button below. Supported file types: **.xlsx**, **.csv**.
            2. **Select the layout** of your plate using the options provided.
            3. **Refer to the plate layout image to understand well positions.**
            4. **Download the example spreadsheet** if you're unsure about the required format.
            5. **Choose wells to inspect** by clicking on the well buttons.
            6. **View the data** for the selected wells in the plot below.
            """)

        # Plate layout image in the second column
        with col2:
            try:
                image_path = "assests/image.png"
                image = Image.open(image_path)
                resized_image = image.resize((400, 300))  # Resize to fit within the column
                st.image(resized_image, caption="96-Well Plate Layout", use_container_width=True)
            except FileNotFoundError:
                st.error(f"Could not find the image at {image_path}. Please check the path.")

        # Example Spreadsheet Download
        st.write("#### Example Spreadsheet:")
        st.write("If you're unsure about the format of the data, download the example spreadsheet below:")
        try:
            with open("assests/example_spreadsheet.xlsx", "rb") as example_file:
                st.download_button(
                    label="📥 Download Example Spreadsheet",
                    data=example_file,
                    file_name="example.xlsx",
                    mime="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                )
        except FileNotFoundError:
            st.error("Example spreadsheet file not found. Please check the path and file name.")

        # File Upload
        uploaded_file = upload_file()

        if uploaded_file is not None:
            with st.spinner("Reading and processing the data..."):
                df = read_data(uploaded_file, rows, columns)
                if df is not None:
                    st.session_state['df'] = df  # Store df in session state
                    
                    st.success("File uploaded and data read successfully!")
                    
                    # Display the data in an expandable section
                    with st.expander("📄 View Raw Data"):
                        st.write(df)
                    
                    # Well Selection for checking data
                    st.subheader("🔬 Select Wells to Plot")
                    st.write("Click on the well buttons below to select or deselect wells for plotting.")
                    
                    # Create well selection buttons
                    selected_wells = create_button_layout(rows, columns, labels, key_prefix="tab1_wells")
                    
                    if selected_wells:
                        st.success(f"Selected Wells: {', '.join(selected_wells)}")
                        
                        # Plot selected wells
                        st.subheader("📊 Plot of Selected Wells")
                        plot_selected_wells(df, selected_wells)
                    else:
                        st.info("No wells selected. Please select wells to display the plot.")
                else:
                    st.error("Error reading the data file. Please check the file format and try again.")
        else:
            st.info("Please upload a data file to proceed.")



    # Tab 2: Background Subtraction
    with tab2:
        if st.session_state['df'] is None:
            st.info("Please upload a file in the 'Upload Data' tab to proceed with background subtraction.")
        else:
            df = st.session_state['df']

            # Specify number of groups
            num_groups = st.number_input("Specify the number of groups for background correction:", min_value=1, step=1)

            # Initialize group data in session state
            if "groups_data" not in st.session_state:
                st.session_state["groups_data"] = {}
            if "selected_sample_wells_by_group" not in st.session_state:
                st.session_state["selected_sample_wells_by_group"] = {}

            groups_data = st.session_state["groups_data"]
            selected_sample_wells_by_group = st.session_state["selected_sample_wells_by_group"]

            # Background Subtraction and Fitting for Each Group
            for group_num in range(1, num_groups + 1):
                st.subheader(f"Group {group_num} Well Selection for Background Correction")
                with st.expander(f"Group {group_num} Blank and Sample Well Selection", expanded=True):
                    # Blank well selection
                    st.write(f"Select blank wells for Group {group_num}")
                    blank_wells_key = f"group_{group_num}_blank_wells"
                    selected_blank_wells = create_button_layout(rows, columns, labels, key_prefix=blank_wells_key)

                    # Display a small preview for the last selected blank well
                    blank_preview_placeholder = st.empty()
                    if selected_blank_wells:
                        last_selected_blank_well = selected_blank_wells[-1]
                        with blank_preview_placeholder:
                            display_single_well_preview(df, last_selected_blank_well)
                    else:
                        blank_preview_placeholder.empty()

                    # Model fitting to blank wells for background correction
                    if selected_blank_wells:
                        st.subheader(f"Fit Model to Blank Wells - Group {group_num}")
                        plot_average(df, selected_blank_wells)
                        selected_model = st.selectbox(
                            f"Select Model for Blank Well Fitting - Group {group_num}",
                            ["Polynomial Growth", "Polynomial Function"],
                            key=f"model_{group_num}"
                        )

                        avg_blank_wells = df[selected_blank_wells].mean(axis=1)
                        if selected_model == "Polynomial Growth":
                            model_func = polynomial_growth
                            popt, pcov = curve_fit(model_func, df['Time'], avg_blank_wells)
                            y_pred = model_func(df['Time'], *popt)
                        elif selected_model == "Polynomial Function":
                            model_func = polynomial_func
                            popt, pcov = curve_fit(model_func, df['Time'], avg_blank_wells)
                            y_pred = model_func(df['Time'], *popt)

                        # Get parameter names for the selected model
                        param_names = MODEL_PARAMS[selected_model]

                        # Create a DataFrame for the fitted parameters
                        param_df = pd.DataFrame({
                            'Parameter': param_names,
                            'Value': popt
                        })

                        # Display the DataFrame
                        st.write(f"### Fitted Parameters for Group {group_num} ({selected_model})")
                        st.dataframe(param_df)

                        # Plot the fitted curves
                        plot_fitted_curves(df, df['Time'], avg_blank_wells, y_pred, selected_model)

                        # Confidence intervals and standard deviation
                        residual_variance = np.var(avg_blank_wells - y_pred, ddof=len(popt))
                        lower_bound, upper_bound = compute_confidence_intervals(
                            df['Time'], popt, pcov, 0.05, len(df['Time']) - len(popt), residual_variance, model_func
                        )
                        plot_confidence_intervals(
                            df, lower_bound, upper_bound, y_pred, df[selected_blank_wells].std(axis=1)
                        )

                    # Sample well selection
                    st.write(f"Select sample wells for Group {group_num}")
                    sample_wells_key = f"group_{group_num}_sample_wells"
                    selected_sample_wells = create_button_layout(rows, columns, labels, key_prefix=sample_wells_key)
                    selected_sample_wells_by_group[group_num] = selected_sample_wells

                    # Preview of the last selected sample well
                    sample_preview_placeholder = st.empty()
                    if selected_sample_wells:
                        last_selected_sample_well = selected_sample_wells[-1]
                        with sample_preview_placeholder:
                            display_single_well_preview(df, last_selected_sample_well)
                    else:
                        sample_preview_placeholder.empty()

                    # Background subtraction for sample wells
                    if selected_blank_wells and selected_sample_wells:
                        st.subheader(f"Background Subtraction for Group {group_num}")
                        groups_data = perform_background_subtraction(
                            groups_data, df, group_num, selected_blank_wells, selected_sample_wells
                        )

                        # Update groups_data in session state
                        st.session_state['groups_data'] = groups_data

                        # Display and plot the background-subtracted data
                        group_df = groups_data[f"Group_{group_num}_bg_subtracted"]
                        st.write(f"### Background-Corrected Data for Group {group_num}")
                        st.write(group_df)
                        plot_selected_wells(group_df, selected_sample_wells)
                        plot_avg_sd_bg_subtracted(group_df, selected_sample_wells, group_num)



    # Step 7: Operations on Background-Subtracted Groups (Handles Single and Multiple Groups)
    # Operations Tab
    # Operations Tab
    with tab3:
        st.subheader("Operations on Background-Subtracted Data")

        if num_groups == 1 and groups_data:
            # Display a message indicating single group data is treated as operated data
            st.info("Only one group is selected. Operations will be performed on the background-subtracted data of this group.")

            # If only one group exists, treat its background-subtracted data as operated data
            group1_data = groups_data.get("Group_1_bg_subtracted")
            sample_wells_group1 = selected_sample_wells_by_group.get(1, [])
            if group1_data is not None and sample_wells_group1:
                st.write("Background-subtracted data for Group 1 (treated as operated data):")
                st.write(group1_data)

                # Plot data for Group 1
                st.subheader("Plot Background-Subtracted Data for Group 1")
                plot_selected_wells(group1_data, sample_wells_group1)
                plot_avg_sd_bg_subtracted(group1_data, sample_wells_group1, group_num=1)

                # Set operated data for phase analysis
                operated_data = group1_data

                # Update selected_operated_wells
                selected_operated_wells = sample_wells_group1
                # Store in session state
                st.session_state["operated_data"] = operated_data
                st.session_state["selected_operated_wells"] = selected_operated_wells

        elif num_groups > 1 and groups_data:
            # Allow operations between two groups if more than one group exists
            group1_data = groups_data.get("Group_1_bg_subtracted")
            group2_data = groups_data.get("Group_2_bg_subtracted")
            if group1_data is not None and group2_data is not None:
                operation = st.selectbox("Select operation", ["Add", "Subtract", "Multiply", "Divide"])
                sample_wells_group1 = selected_sample_wells_by_group.get(1, [])
                sample_wells_group2 = selected_sample_wells_by_group.get(2, [])
                if sample_wells_group1 and sample_wells_group2:
                    group1_data_samples = group1_data[["Time"] + sample_wells_group1]
                    group2_data_samples = group2_data[["Time"] + sample_wells_group2]
                    operated_data = perform_group_operations(group1_data_samples, group2_data_samples, operation)
                    st.write(f"Result of {operation} operation between Group 1 and Group 2")
                    st.write(operated_data)

                    # Plot operated data
                    st.subheader("Plot Operated Data")
                    plot_selected_wells(operated_data, operated_data.columns[1:])
                    plot_avg_sd_operated(operated_data, operated_data.columns[1:])

                    # Update selected_operated_wells with new column names after operation
                    selected_operated_wells = operated_data.columns[1:].tolist()
                    # Store in session state
                    st.session_state["operated_data"] = operated_data
                    st.session_state["selected_operated_wells"] = selected_operated_wells
        else:
            st.warning("No background-subtracted data is available for operations. Please ensure background correction is completed in the 'Background Correction' tab.")




    # Phase Analysis Tab
    # Phase Analysis Tab
    with tab4:
        st.subheader("Phase Analysis")

        # Retrieve operated_data and selected_operated_wells from session state
        operated_data = st.session_state.get("operated_data")
        selected_operated_wells = st.session_state.get("selected_operated_wells", [])

        if df is None:
            st.info("Please upload a file in the 'Upload Data' tab to proceed with Phase Analysis.")
        elif operated_data is not None and selected_operated_wells:
            # Calculate the average over the selected operated wells
            operated_data["Average"] = operated_data[selected_operated_wells].mean(axis=1)

            # Initialize session state for phases
            if "phases" not in st.session_state:
                st.session_state["phases"] = []

            # Display the overall plot for operated data
            st.subheader("Average and Standard Deviation of Operated Data (All Selected Wells)")
            plot_avg_sd_operated(operated_data, selected_operated_wells)

            # Add New Phase Section
            st.subheader("Add a New Phase")
            col1, col2 = st.columns(2)
            with col1:
                new_phase_start = st.number_input(
                    "Start Time for New Phase",
                    min_value=float(operated_data["Time"].min()),
                    max_value=float(operated_data["Time"].max()),
                    step=0.1,
                    key="new_phase_start"
                )
            with col2:
                new_phase_end = st.number_input(
                    "End Time for New Phase",
                    min_value=new_phase_start,
                    max_value=float(operated_data["Time"].max()),
                    step=0.1,
                    key="new_phase_end"
                )

            if st.button("Add New Phase", key="add_new_phase"):
                if new_phase_start < new_phase_end:
                    st.session_state["phases"].append({
                        "start": new_phase_start,
                        "end": new_phase_end,
                        "model": None,
                        "fit": None,  # To store fit results
                        "custom_model_expr": None,
                        "custom_params": []
                    })
                    st.success(f"Added New Phase: Start = {new_phase_start}, End = {new_phase_end}")
                else:
                    st.warning("Ensure the end time is greater than the start time.")

            # Display all phases
            for i, phase in enumerate(st.session_state["phases"]):
                with st.expander(f"Phase {i + 1}"):
                    # Start and End Time Inputs
                    col1, col2 = st.columns(2)
                    with col1:
                        phase_start = st.text_input(
                            f"Start Time for Phase {i + 1}",
                            value=str(phase["start"]),
                            key=f"start_{i}"
                        )
                        try:
                            phase["start"] = float(phase_start)
                        except ValueError:
                            st.error("Invalid start time. Please enter a numeric value.")
                            phase["start"] = None
                    with col2:
                        phase_end = st.text_input(
                            f"End Time for Phase {i + 1}",
                            value=str(phase["end"]),
                            key=f"end_{i}"
                        )
                        try:
                            phase["end"] = float(phase_end)
                        except ValueError:
                            st.error("Invalid end time. Please enter a numeric value.")
                            phase["end"] = None

                    # Filter phase data
                    if phase["start"] is not None and phase["end"] is not None:
                        phase_data = operated_data[
                            (operated_data["Time"] >= phase["start"]) &
                            (operated_data["Time"] <= phase["end"])
                        ][["Time"] + selected_operated_wells]

                        # Drop rows with NaN in selected wells
                        phase_data = phase_data.dropna(subset=selected_operated_wells)

                        if phase_data.empty:
                            st.warning("No data points found in this phase interval.")
                        else:
                            # Calculate average for selected wells
                            phase_data["Average"] = phase_data[selected_operated_wells].mean(axis=1)

                            # Model Selection with 'Custom Function' option
                            phase["model"] = st.selectbox(
                                f"Model for Phase {i + 1}",
                                list(MODEL_FUNCTIONS.keys()),
                                key=f"model_{i}_phase"
                            )

                            # If Custom Function is selected, provide additional inputs
                            if phase["model"] == "Custom Function":
                                st.info("Enter your custom model as a Python expression.")
                                st.write("**Instructions:**")
                                st.write("- Use `t` for time variable.")
                                st.write("- Use parameter names (e.g., `a`, `b`) for parameters to be optimized.")
                                st.write("- Example: `a * t + b`")

                                # Input custom model expression
                                custom_model_expr = st.text_input(
                                    f"Custom Model Expression for Phase {i + 1}",
                                    value="a * t + b",  # Default example
                                    key=f"custom_model_expr_{i}"
                                )

                                # Input parameter names
                                custom_params = st.text_input(
                                    f"Parameters to Optimize (comma-separated) for Phase {i + 1}",
                                    value="a, b",
                                    key=f"custom_params_{i}"
                                )
                                phase["custom_model_expr"] = custom_model_expr
                                phase["custom_params"] = [p.strip() for p in custom_params.split(",") if p.strip()]
                            else:
                                phase["custom_model_expr"] = None
                                phase["custom_params"] = MODEL_PARAMS[phase["model"]]

                            # Display initial guesses for the selected model
                            st.write(f"### Initial Guesses for {phase['model']} Model")
                            initial_guesses = {}
                            if phase["model"] != "Custom Function":
                                model_func = MODEL_FUNCTIONS[phase["model"]]
                                param_names = MODEL_PARAMS[phase["model"]]
                                for param in param_names:
                                    initial_guesses[param] = st.number_input(
                                        f"Initial guess for {param} (Phase {i + 1})",
                                        value=1.0, key=f"{param}_{i}_guess"
                                    )
                            else:
                                # For custom functions, dynamically create input fields for parameters
                                param_names = phase["custom_params"]
                                for param in param_names:
                                    initial_guesses[param] = st.number_input(
                                        f"Initial guess for {param} (Phase {i + 1})",
                                        value=1.0, key=f"{param}_{i}_guess"
                                    )

                            # Fit Model Button
                            if st.button(f"Fit Model for Phase {i + 1}", key=f"fit_model_{i}"):
                                try:
                                    if phase["model"] != "Custom Function":
                                        popt, pcov = curve_fit(
                                            model_func,
                                            phase_data["Time"],
                                            phase_data["Average"],
                                            p0=list(initial_guesses.values())
                                        )
                                        y_pred = model_func(phase_data["Time"], *popt)
                                    else:
                                        # Parse the custom model expression
                                        custom_func = create_custom_model(phase["custom_model_expr"], phase["custom_params"])
                                        if custom_func is None:
                                            st.error("Failed to parse the custom model expression.")
                                            continue

                                        # Perform curve fitting directly with the custom function
                                        popt, pcov = curve_fit(
                                            custom_func,
                                            phase_data["Time"],
                                            phase_data["Average"],
                                            p0=list(initial_guesses.values())
                                        )
                                        y_pred = custom_func(phase_data["Time"], *popt)

                                    st.success("Model fitted successfully!")

                                    # Calculate residuals and variance
                                    residuals = phase_data["Average"] - y_pred
                                    residual_variance = np.var(residuals, ddof=len(popt))

                                    # Compute confidence intervals
                                    if phase["model"] != "Custom Function":
                                        lower_bound, upper_bound = compute_confidence_intervals(
                                            phase_data["Time"].values,
                                            popt,
                                            pcov,
                                            0.05,
                                            len(phase_data) - len(popt),
                                            residual_variance,
                                            model_func
                                        )
                                    else:
                                        lower_bound, upper_bound = compute_confidence_intervals(
                                            phase_data["Time"].values,
                                            popt,
                                            pcov,
                                            0.05,
                                            len(phase_data) - len(popt),
                                            residual_variance,
                                            custom_func
                                        )

                                    # Calculate standard errors
                                    perr = np.sqrt(np.diag(pcov))

                                    # Store fit results in session state
                                    st.session_state["phases"][i]["fit"] = {
                                        "phase": i + 1,
                                        "model": phase["model"],
                                        "phase_time": phase_data["Time"].values,
                                        "fit": y_pred,
                                        "lower_bound": lower_bound,
                                        "upper_bound": upper_bound,
                                        "std_dev": phase_data[selected_operated_wells].std(axis=1).values,
                                        "parameters": popt,
                                        "param_errors": perr
                                    }

                                    st.success(f"Phase {i + 1} fitted successfully!")

                                    # Plot the fitted curves
                                    plot_fitted_curves(phase_data, phase_data["Time"], phase_data["Average"], y_pred, phase["model"])

                                    # Confidence intervals and standard deviation
                                    plot_confidence_intervals(
                                        phase_data,
                                        lower_bound,
                                        upper_bound,
                                        y_pred,
                                        phase_data[selected_operated_wells].std(axis=1)
                                    )

                                except Exception as e:
                                    st.error(f"Error fitting model for Phase {i + 1}: {e}")
                                    # Ensure that 'fit' key is set to None if fitting fails
                                    st.session_state["phases"][i]["fit"] = None

                # Delete Phase Button
                if st.button(f"Delete Phase {i + 1}", key=f"delete_phase_{i}"):
                    st.session_state["phases"].pop(i)
                    st.success(f"Deleted Phase {i + 1}")
                    st.experimental_rerun()

        # Collect all fitted phases
        fitted_phases = [phase["fit"] for phase in st.session_state["phases"] if phase["fit"] is not None]

        if fitted_phases:
            # Plot all phase fits in a single plot
            fig = plot_phase_fit_with_ci(fitted_phases, operated_data, selected_operated_wells)
            st.subheader("All Phase Fits")
            st.plotly_chart(fig, use_container_width=True)

            # Display fitted parameters and standard errors for all phases
            st.subheader("Fitted Parameters and Standard Errors")
            for i, phase in enumerate(st.session_state["phases"]):
                if phase.get("fit") is not None:
                    fit_data = phase["fit"]
                    if "parameters" in fit_data and "param_errors" in fit_data:
                        st.write(f"### Phase {i + 1}: {phase['model']}")
                        if phase["model"] != "Custom Function":
                            param_names = MODEL_PARAMS[phase["model"]]
                        else:
                            param_names = phase["custom_params"]
                        param_table = pd.DataFrame({
                            "Parameter": param_names,
                            "Estimate": fit_data["parameters"],
                            "Std. Error": fit_data["param_errors"]
                        })
                        st.table(param_table)
                    else:
                        st.warning(f"Parameters not available for Phase {i + 1}.")
                else:
                    st.warning(f"No fit available for Phase {i + 1}. Please fit the model.")
        else:
            st.info("No phase fits to display. Please add and fit phases.")



    # Custom ODE Analysis Tab
    # Custom ODE Analysis Tab
     # Custom ODE Analysis Tab
    # Custom ODE Analysis Tab
    with tab5:
        st.header("📈 Custom ODE Phase Analysis")
    
        # Initialize session state for ODE phases
        if "ode_phases" not in st.session_state:
            st.session_state["ode_phases"] = []
        else:
            # Assign unique 'id' to phases missing it
            for phase in st.session_state["ode_phases"]:
                if "id" not in phase:
                    phase["id"] = str(uuid.uuid4())
    
        # Retrieve operated data and selected wells
        operated_data = st.session_state.get("operated_data")
        selected_operated_wells = st.session_state.get("selected_operated_wells", [])
    
        if operated_data is None or not selected_operated_wells:
            st.warning("⚠️ Please perform operations on the data in the 'Operations' tab to enable Custom ODE Analysis.")
        else:
            # Calculate the average over the selected operated wells
            operated_data["Average"] = operated_data[selected_operated_wells].mean(axis=1)
    
            # Display the overall plot for operated data
            st.subheader("📊 Average and Standard Deviation of Operated Data (All Selected Wells)")
            plot_avg_sd_operated(operated_data, selected_operated_wells)
    
            # Add New ODE Phase Section
            st.subheader("➕ Add a New ODE Phase")
            if st.button("Add ODE Phase"):
                new_phase = {
                    "id": str(uuid.uuid4()),  # Unique ID
                    "start": float(operated_data["Time"].min()),
                    "end": float(operated_data["Time"].max()),
                    "variables": ["X", "Y"],  # Default variables
                    "parameters": ["r"],  # Parameters to optimize for X
                    "initial_conditions": [1.0, 0.16],  # Default initial conditions for X and Y
                    "fit_results": None,
                    "odes": ["r * X", "-k * Y"]  # Default ODEs
                }
                st.session_state["ode_phases"].append(new_phase)
                st.success("New ODE Phase added!")
    
            # Process each ODE phase
            for i, phase in enumerate(st.session_state["ode_phases"]):
                with st.expander(f"🔍 ODE Phase {i + 1}"):
                    # Ensure phase has an 'id'
                    phase_id = phase.get('id')
                    if not phase_id:
                        phase_id = str(uuid.uuid4())
                        phase['id'] = phase_id
                    
                    # Time selection with unique keys
                    phase["start"] = st.number_input(
                        f"⏱️ Start Time for Phase {i + 1}",
                        value=phase["start"],
                        min_value=float(operated_data["Time"].min()),
                        max_value=float(operated_data["Time"].max()),
                        step=0.1,
                        key=f"phase_{phase_id}_start"
                    )
                    phase["end"] = st.number_input(
                        f"⏳ End Time for Phase {i + 1}",
                        value=phase["end"],
                        min_value=phase["start"],
                        max_value=float(operated_data["Time"].max()),
                        step=0.1,
                        key=f"phase_{phase_id}_end"
                    )
    
                    # Variables and ODEs
                    variables_input = st.text_input(
                        f"📝 Variables (comma-separated) for Phase {i + 1}",
                        value=", ".join(phase["variables"]),
                        key=f"variables_{phase_id}"
                    )
                    phase["variables"] = [v.strip() for v in variables_input.split(",") if v.strip()]
    
                    odes = []
                    st.write("### 🧮 Enter ODE Expressions")
                    for idx, var in enumerate(phase["variables"]):
                        ode_expr = st.text_input(
                            f"📐 d{var}/dt = ",
                            value=phase["odes"][idx] if idx < len(phase["odes"]) else "",
                            key=f"ode_{phase_id}_{var}"
                        )
                        odes.append(ode_expr)
                    phase["odes"] = odes
    
                    # Parameters to optimize
                    parameters_input = st.text_input(
                        f"🔧 Parameters to Optimize (comma-separated) for Phase {i + 1}",
                        value=", ".join(phase["parameters"]),
                        key=f"parameters_{phase_id}"
                    )
                    phase["parameters"] = [p.strip() for p in parameters_input.split(",") if p.strip()]
    
                    # Initial Conditions
                    st.write("### 🏁 Initial Conditions")
                    initial_conditions = []
                    for idx, var in enumerate(phase["variables"]):
                        ic = st.number_input(
                            f"🔢 Initial condition for {var} at time {phase['start']}",
                            value=phase["initial_conditions"][idx] if idx < len(phase["initial_conditions"]) else 1.0,
                            key=f"ic_{phase_id}_{var}"
                        )
                        initial_conditions.append(ic)
                    phase["initial_conditions"] = initial_conditions
    
                    # Observed Data for the first variable
                    observed_data = operated_data[
                        (operated_data["Time"] >= phase["start"]) &
                        (operated_data["Time"] <= phase["end"])
                    ].copy()
    
                    if observed_data.empty:
                        st.warning("⚠️ No data points found in this phase's time range.")
                    else:
                        st.write("#### 📉 Observed Data for Fitting")
                        plot_avg_sd_operated(observed_data, selected_operated_wells)
    
                        # Parse ODE functions
                        ode_funcs = []
                        parsing_failed = False
                        for expr in phase["odes"]:
                            func = parse_ode(expr, phase["variables"], phase["parameters"])
                            if func:
                                ode_funcs.append(func)
                            else:
                                st.error(f"❌ Failed to parse ODE expression: '{expr}'")
                                parsing_failed = True
                                break
                        if parsing_failed:
                            continue
    
                        # Define the system for solve_ivp
                        def system(t, y, params):
                            return [func(t, y, params) for func in ode_funcs]
    
                        # Cost function for optimization
                        def cost_function(params):
                            try:
                                # Split params into initial conditions and model parameters
                                initial_conditions = params[:len(phase["initial_conditions"])]
                                model_params = params[len(phase["initial_conditions"]):]
    
                                # Solve the ODE
                                sol = solve_ivp(
                                    lambda t, y: system(t, y, model_params),
                                    (observed_data["Time"].values[0], observed_data["Time"].values[-1]),
                                    initial_conditions,
                                    t_eval=observed_data["Time"].values,
                                    method="RK45"
                                )
                                if not sol.success:
                                    return np.inf
    
                                # Calculate residuals for the first variable
                                residuals = observed_data["Average"].values - sol.y[0]
                                return np.sum(residuals**2)
                            except Exception as e:
                                st.error(f"❗ Error in cost function: {e}")
                                return np.inf
    
                        # Combine initial conditions and parameters for optimization
                        st.write("### 🔧 Parameters and Initial Conditions to Optimize")
                        param_names = [f"{var}_0" for var in phase["variables"]] + phase["parameters"]
                        x0 = phase["initial_conditions"] + [0.1] * len(phase["parameters"])
                        bounds = [(0, None)] * len(x0)
                        param_values = []
                        for idx, name in enumerate(param_names):
                            value = st.number_input(
                                f"Initial guess for {name}",
                                value=x0[idx],
                                key=f"param_{phase_id}_{name}"
                            )
                            x0[idx] = value
                            param_values.append(value)
    
                        # Fitting Button
                        if st.button(f"📈 Fit ODE for Phase {i + 1}", key=f"fit_model_{phase_id}"):
                            try:
                                result = minimize(
                                    cost_function,
                                    x0=x0,
                                    bounds=bounds,
                                    method="L-BFGS-B"
                                )
    
                                if result.success:
                                    # Extract optimized initial conditions and model parameters
                                    optimized_initial_conditions = result.x[:len(phase["initial_conditions"])]
                                    optimized_params = result.x[len(phase["initial_conditions"]):]
    
                                    # Solve ODE with optimized values
                                    sol = solve_ivp(
                                        lambda t, y: system(t, y, optimized_params),
                                        (phase["start"], phase["end"]),
                                        optimized_initial_conditions,
                                        t_eval=observed_data["Time"].values,
                                        method="RK45"
                                    )
    
                                    # Store fit results
                                    phase["fit_results"] = {
                                        "initial_conditions": optimized_initial_conditions,
                                        "parameters": optimized_params,
                                        "solution": sol
                                    }
    
                                    # Display parameters in a DataFrame
                                    st.write("### 📊 Optimized Parameters and Initial Conditions")
                                    param_estimates = pd.DataFrame({
                                        "Name": param_names,
                                        "Estimate": result.x
                                    })
                                    st.dataframe(param_estimates)
    
                                    # Plot results
                                    st.write("### 📈 Fitting Results")
                                    fig = go.Figure()
                                    # Plot observed data for the first variable
                                    fig.add_trace(go.Scatter(
                                        x=observed_data["Time"],
                                        y=observed_data["Average"],
                                        mode="markers",
                                        name=f"Observed Data ({phase['variables'][0]})",
                                        marker=dict(color='blue')
                                    ))
                                    # Plot ODE solution for the first variable
                                    fig.add_trace(go.Scatter(
                                        x=sol.t,
                                        y=sol.y[0],
                                        mode="lines",
                                        name=f"Fitted ODE Solution ({phase['variables'][0]})",
                                        line=dict(color='red')
                                    ))
                                    # Plot ODE solutions for other variables
                                    for idx_var, var in enumerate(phase["variables"][1:], start=1):
                                        fig.add_trace(go.Scatter(
                                            x=sol.t,
                                            y=sol.y[idx_var],
                                            mode="lines",
                                            name=f"🔄 ODE Solution ({var})",
                                            line=dict(dash='dash')
                                        ))
                                    fig.update_layout(
                                        title=f"ODE Fit Results for Phase {i + 1}",
                                        xaxis_title="Time",
                                        yaxis_title="Value",
                                        template="plotly_white"
                                    )
                                    st.plotly_chart(fig)
    
                                    # Indicate which parameters are estimated
                                    st.write("Note: The above parameters include estimated initial conditions and model parameters for the first variable.")
                                    st.write("Variables like 'Y' are part of the ODE system but not estimated due to lack of observed data.")
    
                                else:
                                    st.error(f"❌ Optimization failed: {result.message}")
                            except Exception as e:
                                st.error(f"❗ Error during optimization: {e}")
    
                    # Delete Phase Button with Unique Key
                    if st.button(f"🗑️ Delete ODE Phase {i + 1}", key=f"delete_phase_{phase_id}"):
                        st.session_state["ode_phases"].pop(i)
                        st.success(f"🗑️ Deleted ODE Phase {i + 1}")
                        st.experimental_rerun()
    
            # Display all fitted ODEs with Average Data over entire time
            st.subheader("📚 All Fitted ODE Phases with Average Data")
            for i, phase in enumerate(st.session_state["ode_phases"]):
                if phase.get("fit_results") and phase["fit_results"].get("solution"):
                    fit_results = phase["fit_results"]
                    sol = fit_results["solution"]
    
                    fig = go.Figure()
    
                    # Plot the average data over the entire time period for the first variable
                    fig.add_trace(go.Scatter(
                        x=operated_data["Time"],
                        y=operated_data["Average"],
                        mode='markers',
                        name=f'📊 Observed Average Data ({phase["variables"][0]})',
                        marker=dict(color='blue')
                    ))
    
                    # Plot the ODE solution for the first variable
                    fig.add_trace(go.Scatter(
                        x=sol.t,
                        y=sol.y[0],
                        mode="lines",
                        name=f"📈 Fitted ODE Solution ({phase['variables'][0]})",
                        line=dict(width=2, color='red')
                    ))
    
                    # Plot the ODE solution for other variables
                    for idx_var, var in enumerate(phase["variables"][1:], start=1):
                        fig.add_trace(go.Scatter(
                            x=sol.t,
                            y=sol.y[idx_var],
                            mode="lines",
                            name=f"🔄 ODE Solution ({var})",
                            line=dict(width=2, dash='dash')
                        ))
    
                    fig.update_layout(
                        title=f"📈 ODE Phase {i + 1} Solutions with Observed Data",
                        xaxis_title='🕒 Time',
                        yaxis_title='🔬 Value',
                        template='plotly_white'
                    )
                    st.plotly_chart(fig, use_container_width=True)
                else:
                    st.info(f"ℹ️ ODE Phase {i + 1} has not been fitted yet.")
    # Tab 6: Automatic Phase Detection
    with tab6:
        st.header("🔍 Automatic Phase Detection")

        # Check if operated data is available
        operated_data = st.session_state.get("operated_data")
        selected_operated_wells = st.session_state.get("selected_operated_wells", [])

        if operated_data is None or not selected_operated_wells:
            st.warning("⚠️ Please perform operations on the data in the 'Operations' tab to enable Automatic Phase Detection.")
        else:
            # Calculate the average over the selected operated wells
            operated_data["Average"] = operated_data[selected_operated_wells].mean(axis=1)

            st.subheader("📊 Average Operated Data")
            plot_average(operated_data, ["Average"])

            # Phase Detection Parameters
            st.subheader("🛠️ Phase Detection Parameters")
            model = st.selectbox(
                "Select Model for Change Point Detection",
                ["l2", "rbf", "linear"],
                help="Choose the cost function for change point detection."
            )
            pen = st.slider(
                "Select Penalty Value",
                min_value=0.0,
                max_value=100.0,
                value=10.0,
                step=0.5,
                help="Higher penalty leads to fewer change points."
            )

            # Button to perform phase detection
            if st.button("Detect Phases"):
                try:
                    time = operated_data["Time"].values
                    od_values = operated_data["Average"].values

                    # Detect phases
                    phases, breakpoints = detect_phases(time, od_values, model=model, pen=pen)

                    if len(phases) == 0:
                        st.error("No phases detected. Try adjusting the penalty value.")
                    else:
                        st.success(f"Detected {len(phases)} phase(s).")
                        st.session_state["automatic_phases"] = phases
                        st.session_state["automatic_breakpoints"] = breakpoints

                        # Plot the detected phases
                        plot_detected_phases(time, od_values, phases)

                        # Display phase details
                        st.subheader("📋 Detected Phases")
                        phase_details = []
                        for idx, (start, end) in enumerate(phases):
                            phase_details.append({
                                "Phase": f"Phase {idx + 1}",
                                "Start Time": start,
                                "End Time": end,
                                "Duration": end - start
                            })
                        phase_df = pd.DataFrame(phase_details)
                        st.table(phase_df)

                except Exception as e:
                    st.error(f"❌ Error during phase detection: {e}")

    # Tab 7: Growth Models
    with tab7:
        st.title("Bacterial Growth Models")

        st.write("## Exponential Growth Model")
        st.write("The exponential growth model is described by the following equations:")
        st.latex(r'''
            \frac{dX}{dt} = \mu X
        ''')
        st.latex(r'''
            x(t) = X_0 e^{\mu t}
        ''')
        st.code("""
    def exponential_growth(t, mu, X0):
        return X0 * np.exp(mu * t)
        """)
        st.write(" where x0 is the initial bacterial biomass at time 0, mu is the growth rate")

        st.write("## Logistic Growth Model")
        st.write("The logistic growth model with saturation is described by the following equations:")
        st.latex(r'''
            \frac{dX}{dt} = \mu X \left(1 - \frac{X}{K}\right)
        ''')
        st.latex(r'''
            x(t) = \frac{X_0 e^{\mu t}}{1 + \frac{X_0}{K} \left(e^{\mu t} - 1\right)}
        ''')
        st.write("where X is the biomass, X0 is the initial biomass at time 0, mu is the growth rate, K is the saturation constant (maximal OD)")
        st.code("""
    def logistic_growth(t, mu, X0, K):
        return (X0 * np.exp(mu * t)) / (1 + (X0 / K) * (np.exp(mu * t) - 1))
        """)

        st.write("## Baranyi Model")
        st.write("The Baranyi model for lag-exponential growth is described by the following equations:")
        st.latex(r'''
            \frac{dX}{dt} = \mu \frac{q(t)}{1 + q(t)} X
        ''')
        st.latex(r'''
            \frac{dq}{dt} = \mu q
        ''')
        st.latex(r'''
            x(t) = X_0 \frac{1 + q_0 e^{\mu t}}{1 + q_0}
        ''')
        st.code("""
    def baranyi_growth(t, X0, mu, q0):
        q_t = q0 * np.exp(mu * t)
        return X0 * (1 + q_t) / (1 + q0)
        """)
        st.write("where x0 is the initial biomass at time 0, mu is the growth rate, q0 is a physiological state of the cell in constant environment (for example the enzymes that need to accumulate to adapt to the new condition).")

        st.write("## Lag-Exponential-Saturation Growth Model")
        st.write("The lag-exponential-saturation growth model is described by the following equations:")
        st.latex(r'''
            \frac{dX}{dt} = \mu \frac{q(t)}{1 + q(t)} X \left(1 - \frac{X}{K}\right)
        ''')
        st.latex(r'''
            \frac{dq}{dt} = \mu q
        ''')
        st.latex(r'''
            x(t) = X_0 \frac{1 + q_0 e^{\mu t}}{1 + q_0 - q_0 \frac{X_0}{K} + \frac{q_0 X_0}{K} e^{\mu t}}
        ''')
        st.code("""
    def lag_exponential_saturation_growth(t, mu, X0, q0, K):
        return X0 * (1 + q0 * np.exp(mu * t)) / (1 + q0 - q0 * (X0 / K) + (q0 * X0 / K) * np.exp(mu * t))
        """)
        st.write("where x0 is the initial biomass at time 0, K is the saturation constant (maximal OD), mu is the growth rate, q0 is a physiological state of the cell in constant environment (for example the enzymes that need to accumulate to adapt to the new condition).")
        st.write("X and X0 are usually measured in [a.u.] at OD600 or in concentration units, K has the same units of the biomass, mu is measured in [1/t], q0  is adimensional.")




if __name__ == "__main__":
    main()
