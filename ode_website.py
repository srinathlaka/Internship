import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
import numpy as np
from scipy.integrate import odeint
from scipy.optimize import curve_fit

# Define the growth models
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

# Example of a user-defined ODE model
class UserProvidedODE:
    def __init__(self, ode_function):
        self.ode_function = ode_function

    def model_fun(self, state, t, *params):
        return eval(self.ode_function)

# Function to solve the ODE
def solve_ode(model, t, *params):
    state0 = [0.01]  # Initial condition for the ODE
    sol = odeint(model.model_fun, state0, t, args=params)
    return sol[:, 0]

# Function to parse the user-provided ODE function
def parse_ode_function(ode_function):
    try:
        num_params = ode_function.count('params[')
        return num_params
    except Exception as e:
        st.error(f"Invalid ODE function: {e}")
        return None

# Initialize session state for phases
def initialize_session_state():
    if 'phases' not in st.session_state:
        st.session_state.phases = []
    for phase in st.session_state.phases:
        phase.setdefault('start', 0)
        phase.setdefault('end', 0)
        phase.setdefault('model', 'Exponential')
        phase.setdefault('automatic', False)
        phase.setdefault('initial_guesses', {})

# Add a new phase
def add_phase():
    st.session_state.phases.append({'start': 0, 'end': 0, 'model': 'Exponential', 'automatic': False, 'initial_guesses': {}})

# Delete a phase
def delete_phase(index):
    st.session_state.phases.pop(index)

# Fit the model to the phase data
def fit_model_to_phase(phase, phase_data):
    models = {
        'Exponential': (exponential_growth, [0.0001, phase_data['Average'].iloc[0]]),
        'Logistic': (logistic_growth, [0.0001, phase_data['Average'].iloc[0], 1.0]),
        'Baranyi': (baranyi_growth, [phase_data['Average'].iloc[0], 0.0001, 1.0]),
        'Lag-Exponential-Saturation': (lag_exponential_saturation_growth, [0.0001, phase_data['Average'].iloc[0], 1.0, 1.0])
    }
    
    if phase['automatic']:
        return fit_automatic_model(models, phase_data)
    else:
        return fit_selected_model(models, phase, phase_data)

# Automatic model fitting
def fit_automatic_model(models, phase_data):
    best_model = None
    best_aic = float('inf')
    best_fit = None
    best_popt = None
    for model_name, (model_func, initial_params) in models.items():
        try:
            popt, _ = curve_fit(model_func, phase_data['Time'], phase_data['Average'], p0=initial_params, maxfev=10000)
            fit = model_func(phase_data['Time'], *popt)
            rss, r_squared, aic = calculate_metrics(phase_data['Average'], fit, len(popt))
            if aic < best_aic:
                best_aic = aic
                best_model = model_name
                best_fit = fit
                best_popt = popt
        except Exception as e:
            st.write(f"Error fitting {model_name}: {e}")
    return best_model, best_fit, best_popt

# Selected model fitting
def fit_selected_model(models, phase, phase_data):
    if phase['model'] == 'UserProvidedODE':
        return fit_user_provided_ode(phase, phase_data)
    else:
        return fit_standard_model(models, phase, phase_data)

# Fit user-provided ODE model
def fit_user_provided_ode(phase, phase_data):
    model = UserProvidedODE(phase['ode_function'])
    initial_guess = [phase.get(f'param{j+1}', 0.1) for j in range(len(model.ode_function.split('params')) - 1)]
    try:
        popt, _ = curve_fit(lambda t, *params: solve_ode(model, t, *params), phase_data['Time'], phase_data['Average'], p0=initial_guess)
        fit = solve_ode(model, phase_data['Time'], *popt)
        return phase['model'], fit, popt
    except Exception as e:
        st.write(f"Error fitting model: {e}")
        return None, None, None

# Fit standard model
def fit_standard_model(models, phase, phase_data):
    model_func, initial_params = models[phase['model']]
    popt, _ = curve_fit(model_func, phase_data['Time'], phase_data['Average'], p0=initial_params, maxfev=10000)
    fit = model_func(phase_data['Time'], *popt)
    return phase['model'], fit, popt

# Main Streamlit app
st.title("Bacterial Growth Phases Analysis")

# File uploader
uploaded_file = st.file_uploader("Upload your CSV file", type="csv")

if uploaded_file is not None:
    # Read the data
    data = pd.read_csv(uploaded_file)
    
    # Display the data
    st.write("### Uploaded Data")
    st.write(data.head())

    # Initialize session state for phases
    initialize_session_state()

    # Plot the data
    fig = px.line(data, x='Time', y='Average', markers=True, title='Time vs Average',
                  labels={'Time': 'Time', 'Average': 'Average'},
                  hover_data={'Time': True, 'Average': True})

    colors = ['lightgreen', 'lightblue', 'lightcoral', 'lightyellow', 'lightgrey']
    for i, phase in enumerate(st.session_state.phases):
        color = colors[i % len(colors)]
        fig.add_vrect(x0=float(phase['start']), x1=float(phase['end']), fillcolor=color, opacity=0.3, line_width=0,
                      annotation_text=f"Phase {i + 1}", annotation_position="top left")

    st.plotly_chart(fig)

    # Display the phases in a single line
    for i, phase in enumerate(st.session_state.phases):
        with st.expander(f"Phase {i + 1}"):
            col1, col2 = st.columns(2)
            with col1:
                phase['start'] = st.text_input(f'Start Time for Phase {i + 1}', value=str(phase['start']), key=f'start_{i}')
            with col2:
                phase['end'] = st.text_input(f'End Time for Phase {i + 1}', value=str(phase['end']), key=f'end_{i}')
            
            phase['automatic'] = st.checkbox(f'Automatic Fit', value=phase['automatic'], key=f'automatic_{i}')
            if not phase['automatic']:
                phase['model'] = st.selectbox(f'Model', ['Exponential', 'Logistic', 'Baranyi', 'Lag-Exponential-Saturation', 'UserProvidedODE'], index=0, key=f'model_{i}')
            
            phase_data = data[(data['Time'] > float(phase['start'])) & (data['Time'] <= float(phase['end']))]
            
            if phase['model'] == 'UserProvidedODE' and not phase['automatic']:
                phase['ode_function'] = st.text_area(f'ODE Function for Phase {i + 1}', value='params[0] * state[0] * (1 - state[0] / params[1])', key=f'ode_function_{i}')
                st.write("Hint: Write the ODE in terms of state and params, e.g., 'params[0] * state[0] * (1 - state[0] / params[1])'")
                st.write("""
                    ### Examples:
                    - Logistic growth: `params[0] * state[0] * (1 - state[0] / params[1])`
                    - Exponential growth: `params[0] * state[0]`
                    """)
                
                num_params = parse_ode_function(phase['ode_function'])
                if num_params is not None:
                    for param in range(num_params):
                        phase[f'param{param+1}'] = st.number_input(f'Parameter {param+1} for Phase {i + 1}', value=0.1, key=f'param{param+1}_{i}')
            elif not phase['automatic']:
                st.write(f"### Initial Guesses for {phase['model']} Model")
                initial_guesses = {}
                if not phase_data.empty:
                    if phase['model'] == 'Exponential':
                        cols = st.columns(2)
                        initial_guesses['mu'] = cols[0].number_input('Initial guess for mu', value=0.0001, key=f'mu_{i}')
                        initial_guesses['X0'] = cols[1].number_input('Initial guess for X0', value=phase_data['Average'].iloc[0], key=f'X0_{i}')
                    elif phase['model'] == 'Logistic':
                        cols = st.columns(3)
                        initial_guesses['mu'] = cols[0].number_input('Initial guess for mu', value=0.0001, key=f'mu_{i}')
                        initial_guesses['X0'] = cols[1].number_input('Initial guess for X0', value=phase_data['Average'].iloc[0], key=f'X0_{i}')
                        initial_guesses['K'] = cols[2].number_input('Initial guess for K', value=1.0, key=f'K_{i}')
                    elif phase['model'] == 'Baranyi':
                        cols = st.columns(3)
                        initial_guesses['X0'] = cols[0].number_input('Initial guess for X0', value=phase_data['Average'].iloc[0], key=f'X0_{i}')
                        initial_guesses['mu'] = cols[1].number_input('Initial guess for mu', value=0.0001, key=f'mu_{i}')
                        initial_guesses['q0'] = cols[2].number_input('Initial guess for q0', value=1.0, key=f'q0_{i}')
                    elif phase['model'] == 'Lag-Exponential-Saturation':
                        cols = st.columns(4)
                        initial_guesses['mu'] = cols[0].number_input('Initial guess for mu', value=0.0001, key=f'mu_{i}')
                        initial_guesses['X0'] = cols[1].number_input('Initial guess for X0', value=phase_data['Average'].iloc[0], key=f'X0_{i}')
                        initial_guesses['q0'] = cols[2].number_input('Initial guess for q0', value=1.0, key=f'q0_{i}')
                        initial_guesses['K'] = cols[3].number_input('Initial guess for K', value=1.0, key=f'K_{i}')
                    phase['initial_guesses'] = initial_guesses

            if st.button('Delete Phase', key=f'delete_{i}'):
                delete_phase(i)
                st.experimental_rerun()

    # Add Phase button
    st.button('Add Phase', on_click=add_phase)

    # Fit the models
    for i, phase in enumerate(st.session_state.phases):
        st.write(f"### Fit Results for Phase {i + 1}")
        phase_data = data[(data['Time'] > float(phase['start'])) & (data['Time'] <= float(phase['end']))]
        
        if not phase_data.empty:
            model_name, fit, popt = fit_model_to_phase(phase, phase_data)
            if model_name:
                metrics = calculate_metrics(phase_data['Average'], fit, len(popt))
                metrics_df = pd.DataFrame({
                    "Model": [model_name],
                    "RSS": [metrics[0]],
                    "R-squared": [metrics[1]],
                    "AIC": [metrics[2]]
                })
                st.write(metrics_df)
                params_df = pd.DataFrame([popt], columns=['Parameter ' + str(i+1) for i in range(len(popt))])
                st.write(f"### Fitted Parameters for Phase {i + 1}")
                st.write(params_df)
                fig.add_trace(go.Scatter(x=phase_data['Time'], y=fit, mode='lines', name=f'{model_name} Fit Phase {i + 1}'))
            else:
                st.write(f"Failed to fit the model for Phase {i + 1}")

    st.plotly_chart(fig)

# Potential Improvements
st.write("""
### Potential Improvements
- Improve error messages to be more user-friendly and informative.
- Handle cases where the fit might fail due to poor initial guesses or data issues.
- Modularize the code further by breaking down large chunks into smaller functions or classes.
- Use comments and docstrings to explain the purpose of each function and class.
- Provide more context or examples for initial parameter guesses, especially for more complex models like UserProvidedODE.
- Implement a mechanism to save and load phase configurations to avoid re-entering information on app refresh.
- Add a progress indicator when fitting models, especially for automatic fitting which can be time-consuming.
- Allow users to download the fitted results and parameters for further analysis.
- Include a summary section that provides an overview of all phases and their respective fit metrics.
""")
