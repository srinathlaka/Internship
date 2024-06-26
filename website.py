import streamlit as st
import pandas as pd
import numpy as np
from scipy.optimize import curve_fit
from scipy.stats import t
import plotly.express as px
import plotly.graph_objects as go

# Define growth models
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
def compute_confidence_intervals(time, params, covariance, alpha, dof, residual_variance):
    t_critical = t.ppf(1 - alpha / 2, dof)
    J = np.zeros((len(time), len(params)))
    J[:, 0] = np.power(time, params[1])
    J[:, 1] = params[0] * np.log(time + 1e-8) * np.power(time, params[1])  # Adding small constant to avoid log(0)
    J[:, 2] = 1
    conf_interval = np.zeros(len(time))
    fitted_od_growth = polynomial_growth(time, *params)
    for i in range(len(time)):
        gradient = J[i, :]
        conf_interval[i] = np.sqrt(np.dot(gradient, np.dot(covariance, gradient.T)) + residual_variance)
    lower_bound = fitted_od_growth - t_critical * conf_interval
    upper_bound = fitted_od_growth + t_critical * conf_interval
    return lower_bound, upper_bound

# Upload file
def upload_file():
    uploaded_file = st.file_uploader("Choose a file", type=["xlsx", "csv"])
    return uploaded_file

# Read data
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
    
    # Ensure we have a 'Time' column and the rest are well labels
    if df.shape[1] < total_columns + 1:
        # Append missing columns with NaNs
        extra_cols = pd.DataFrame(np.nan, index=df.index, columns=range(df.shape[1], total_columns + 1))
        df = pd.concat([df, extra_cols], axis=1)
    
    df = df.iloc[:, :total_columns + 1]  # Trim excess columns if any
    df.columns = ["Time"] + labels  # Assign generated labels to the columns
    return df

# Generate labels for well selection
def generate_labels(rows, cols):
    labels = []
    for i in range(rows):
        for j in range(cols):
            label = chr(ord('A') + i) + str(j + 1)
            labels.append(label)
    return labels

# Create a button layout for selecting wells using generated labels
def create_button_layout(rows, columns, labels):
    selected_wells = []
    index = 0
    with st.container():
        for i in range(rows):
            cols_ui = st.columns(columns)  # Create a Streamlit columns container per row
            for j in range(columns):
                well_name = labels[index]
                if cols_ui[j].button(well_name):  # Use button in the corresponding column
                    selected_wells.append(well_name)
                index += 1
    st.write("Selected Wells:", ', '.join(selected_wells))

# Plot fitted curves with Plotly
def plot_fitted_curves(df, time, observed, fitted, model_name):
    fig = go.Figure()
    fig.add_trace(go.Scatter(x=time, y=observed, mode='lines', name='Observed Data'))
    fig.add_trace(go.Scatter(x=time, y=fitted, mode='lines', name=f'Fitted Curve ({model_name})', line=dict(color='red')))
    fig.update_layout(title=f'Fitted {model_name} Model', xaxis_title='Time', yaxis_title='OD', legend_title='Legend', template='plotly_white')
    st.plotly_chart(fig)

# Plot confidence intervals with Plotly
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

# Fit growth model
def fit_growth_model(model_type, data_x, data_y):
    if model_type == "Polynomial Growth":
        popt, pcov = curve_fit(polynomial_growth, data_x, data_y)
        return popt, pcov
    elif model_type == "Polynomial Function":
        popt, pcov = curve_fit(polynomial_func, data_x, data_y)
        return popt, pcov
    else:
        raise ValueError("Invalid model type")

# Plot average and standard deviation with Plotly
def plot_avg_and_std(df, selected_wells, y_pred=None, std_dev=None, log_scale=False):
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
            line=dict(color='rgba(255,255,255,0)'),
            hoverinfo="skip",
            showlegend=True,
            name='Standard Deviation'
        ))

        if y_pred is not None:
            fig.add_trace(go.Scatter(x=df['Time'], y=y_pred, mode='lines', name='Fitted Curve', line=dict(color='red')))

        fig.update_layout(
            title='Average Measurement with Standard Deviation',
            xaxis_title='Time',
            yaxis_title='Average Measurement',
            legend_title='Legend',
            template='plotly_white'
        )

        if log_scale:
            fig.update_yaxes(type="log")

        st.plotly_chart(fig)

# Plot selected wells with Plotly
def plot_selected_wells(df, selected_wells):
    fig = go.Figure()
    for well in selected_wells:
        fig.add_trace(go.Scatter(x=df['Time'], y=df[well], mode='lines', name=well))
    fig.update_layout(title="Time vs Selected Well's OD", xaxis_title='Time', yaxis_title='OD', legend_title='Legend', template='plotly_white')
    st.plotly_chart(fig)

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

# Select wells using buttons
def select_wells(df, rows, columns, labels, message, session_key):
    if session_key not in st.session_state:
        st.session_state[session_key] = set()

    selected_wells = sorted(list(st.session_state[session_key]))

    with st.container():
        for i in range(rows):
            cols = st.columns(columns)
            for j in range(columns):
                index = i * columns + j
                if index < len(labels):
                    button_label = labels[index]
                    if button_label != "Time":
                        button_key = f"button_{session_key}_{i}_{j}"
                        if cols[j].button(button_label, key=button_key):
                            if button_label in selected_wells:
                                selected_wells.remove(button_label)
                            else:
                                selected_wells.append(button_label)
                            selected_wells = sorted(selected_wells)
                            st.session_state[session_key] = set(selected_wells)

    selected_wells_text = f"Currently Selected Wells: " + ", ".join(selected_wells) if selected_wells else "None"
    message.write(selected_wells_text)

    return selected_wells

# Clear selected wells
def clear_selected_wells(session_key, message):
    st.session_state[session_key].clear()
    message.warning("Selected wells cleared.")

# Perform background subtraction and model fitting
def perform_background_subtraction(df, selected_blank_wells, selected_sample_replicates, y_pred):
    if len(selected_blank_wells) == 0 or len(selected_sample_replicates) == 0:
        st.warning("Please select both blank wells and sample replicates for subtraction.")
        return None

    selected_blank_wells_list = list(selected_blank_wells)
    blank_mean = df[selected_blank_wells_list].mean(axis=1)

    for sample_replicate in selected_sample_replicates:
        df[sample_replicate] = df[sample_replicate] - blank_mean

    return df

def main():
    st.set_page_config(page_title="Bacterial Growth Analysis", page_icon="🔬", layout="wide")
    st.markdown("<h1 style='text-align: center; color: #4CAF50;'>Bacterial Growth Analysis</h1>", unsafe_allow_html=True)

    with st.expander("Instructions for Using the Bacterial Growth Analysis Tool"):
        st.markdown("""
        1. **Upload Your Data**:
           - Click on "Choose a file" to upload your dataset in .xlsx or .csv format. Ensure your data includes a 'Time' column and OD measurements for each well.

        2. **Select Well Layout**:
           - Choose a pre-defined well layout from the dropdown or enter custom dimensions for rows and columns.

        3. **Select Wells for Analysis**:
           - Use the generated buttons to select wells for blanks and samples. Selected wells will be highlighted.

        4. **Fit Growth Model**:
           - Choose the desired growth model (Polynomial Growth or Polynomial Function) and fit the model to your data. View the fitted curve and confidence intervals.

        5. **Background Subtraction**:
           - Perform background subtraction by selecting blank wells and sample replicates. The adjusted data will be displayed for further analysis.

        6. **Visualize Results**:
           - View various plots including the observed data, fitted curves, average measurements, and standard deviations. Toggle options to customize the display.
        """)

    st.sidebar.header("Bacterial Growth Analysis")
    st.sidebar.write("Please upload the files in .xlsx or .csv format only")

    rows, columns = select_layout()
    uploaded_file = upload_file()

    if uploaded_file is not None:
        df = read_data(uploaded_file, rows, columns)
        if df is not None:
            try:
                labels = generate_labels(rows, columns)
                st.write(f"Grid dimensions: {rows} rows x {columns} columns")
                st.write(df)
            except ValueError as ve:
                st.error(f"Error: {ve}")
                st.write(f"Length of labels list: {len(labels)}")
                st.write(f"Number of columns in DataFrame: {df.shape[1]}")
                return

            st.subheader("Select Blank Wells")
            selected_blank_wells_message = st.empty()
            selected_blank_wells = select_wells(df, rows, columns, labels, selected_blank_wells_message, "selected_blank_wells")
            std_dev_blank_cells = df[selected_blank_wells].std(axis=1)

            plots_before_bg_subtraction = st.checkbox("Compare plots of selected blank wells")
            if plots_before_bg_subtraction:
                plot_selected_wells(df, selected_blank_wells)

            average_blank_cells = st.checkbox("View average of selected blank wells")
            if average_blank_cells:
                plot_average(df, selected_blank_wells)
                fit_average = st.checkbox("Fit average")
                if fit_average:
                    selected_model = st.selectbox("Select Growth Model", ["Polynomial Growth", "Polynomial Function"])
                    st.write("Fit of the average blank cells")
                    popt, pcov = fit_growth_model(selected_model, df['Time'], df['Average'])
                    st.write("Parameter values (popt):", popt)
                    if selected_model == "Polynomial Growth":
                        y_pred = polynomial_growth(df['Time'], *popt)
                    elif selected_model == "Polynomial Function":
                        y_pred = polynomial_func(df['Time'], *popt)

                    plot_avg_and_std(df, selected_blank_wells, y_pred, std_dev_blank_cells)

                    compute_ci = st.checkbox("Calculate Confidence Intervals")
                    if compute_ci:
                        residuals = df['Average'] - y_pred
                        dof = len(df['Time']) - len(popt)
                        residual_variance = np.var(residuals, ddof=dof)
                        lower_bound, upper_bound = compute_confidence_intervals(df['Time'], popt, pcov, 0.05, dof, residual_variance)
                        plot_confidence_intervals(df, lower_bound, upper_bound, y_pred, std_dev_blank_cells)

            clear_blank_wells_button = st.button("Clear selected blank wells")
            if clear_blank_wells_button:
                clear_selected_wells("selected_blank_wells", selected_blank_wells_message)

            st.subheader("Select Sample Replicates")
            selected_sample_replicates_message = st.empty()
            selected_sample_replicates = select_wells(df, rows, columns, labels, selected_sample_replicates_message, "selected_sample_replicates")

            clear_sample_replicates_button = st.button("Clear selected sample replicates")
            if clear_sample_replicates_button:
                clear_selected_wells("selected_sample_replicates", selected_sample_replicates_message)

            Perform_Background_Subtraction = st.checkbox("Perform background subtraction")
            if Perform_Background_Subtraction:
                df_bg_subtracted = perform_background_subtraction(df.copy(), selected_blank_wells, selected_sample_replicates, y_pred)
                if df_bg_subtracted is not None:
                    st.success("Background subtraction completed successfully!")
                    st.write(df_bg_subtracted)
                    selected_wells = st.session_state.selected_sample_replicates
                    plot_selected_wells(df_bg_subtracted, selected_wells)
                    
                    plot_average(df_bg_subtracted, selected_wells)
                    plot_avg_and_std(df_bg_subtracted, selected_wells)

                # Manual phase selection
                st.write("### Select Phases Manually")
                lag_phase_end_time = st.number_input('Lag Phase End Time', min_value=float(df['Time'].min()), max_value=float(df['Time'].max()), value=2400.0)
                log_phase_end_time = st.number_input('Log Phase End Time', min_value=float(df['Time'].min()), max_value=float(df['Time'].max()), value=49000.0)
                stationary_phase_end_time = st.number_input('Stationary Phase End Time', min_value=float(df['Time'].min()), max_value=float(df['Time'].max()), value=69000.0)
                death_phase_end_time = st.number_input('Death Phase End Time', min_value=float(df['Time'].min()), max_value=float(df['Time'].max()), value=float(df['Time'].max()))

                phase_to_fit = st.selectbox('Select Phase to Fit', ['Lag Phase', 'Log Phase', 'Stationary Phase', 'Death Phase'])

                # Determine the start and end times for the selected phase
                if phase_to_fit == 'Lag Phase':
                    fit_start_time = 0
                    fit_end_time = lag_phase_end_time
                elif phase_to_fit == 'Log Phase':
                    fit_start_time = lag_phase_end_time
                    fit_end_time = log_phase_end_time
                elif phase_to_fit == 'Stationary Phase':
                    fit_start_time = log_phase_end_time
                    fit_end_time = stationary_phase_end_time
                elif phase_to_fit == 'Death Phase':
                    fit_start_time = stationary_phase_end_time
                    fit_end_time = death_phase_end_time

                # Plot phases before fitting
                fig = px.line(df_bg_subtracted, x='Time', y='Average', markers=True, title='Time vs Average',
                              labels={'Time': 'Time', 'Average': 'Average'},
                              hover_data={'Time': True, 'Average': True})

                fig.update_layout(title='Time vs Average with Phases')
                fig.add_vrect(x0=0, x1=lag_phase_end_time, fillcolor="red", opacity=0.3, line_width=0, annotation_text="Lag Phase", annotation_position="top left")
                fig.add_vrect(x0=lag_phase_end_time, x1=log_phase_end_time, fillcolor="green", opacity=0.3, line_width=0, annotation_text="Log Phase", annotation_position="top left")
                fig.add_vrect(x0=log_phase_end_time, x1=stationary_phase_end_time, fillcolor="blue", opacity=0.3, line_width=0, annotation_text="Stationary Phase", annotation_position="top left")
                fig.add_vrect(x0=stationary_phase_end_time, x1=death_phase_end_time, fillcolor="yellow", opacity=0.3, line_width=0, annotation_text="Transition Phase", annotation_position="top left")
                fig.add_vrect(x0=death_phase_end_time, x1=df_bg_subtracted['Time'].max(), fillcolor="purple", opacity=0.3, line_width=0, annotation_text="Death Phase", annotation_position="top left")

                st.plotly_chart(fig)

                phase_data = df_bg_subtracted[(df_bg_subtracted['Time'] > fit_start_time) & (df_bg_subtracted['Time'] <= fit_end_time)]

                if not phase_data.empty:
                    # Fit the models
                    initial_params_exp = [0.0001, phase_data['Average'].iloc[0]]
                    initial_params_log = [0.0001, phase_data['Average'].iloc[0], 1.0]
                    initial_params_baranyi = [phase_data['Average'].iloc[0], 0.0001, 1.0]
                    initial_params_lag_exp_sat = [0.0001, phase_data['Average'].iloc[0], 1.0, 1.0]

                    popt_exp, _ = curve_fit(exponential_growth, phase_data['Time'], phase_data['Average'], p0=initial_params_exp, maxfev=10000)
                    popt_log, _ = curve_fit(logistic_growth, phase_data['Time'], phase_data['Average'], p0=initial_params_log, maxfev=10000)
                    popt_baranyi, _ = curve_fit(baranyi_growth, phase_data['Time'], phase_data['Average'], p0=initial_params_baranyi, maxfev=10000)
                    popt_lag_exp_sat, _ = curve_fit(lag_exponential_saturation_growth, phase_data['Time'], phase_data['Average'], p0=initial_params_lag_exp_sat, maxfev=10000)

                    # Calculate fitted values
                    fit_exp = exponential_growth(phase_data['Time'], *popt_exp)
                    fit_log = logistic_growth(phase_data['Time'], *popt_log)
                    fit_baranyi = baranyi_growth(phase_data['Time'], *popt_baranyi)
                    fit_lag_exp_sat = lag_exponential_saturation_growth(phase_data['Time'], *popt_lag_exp_sat)

                    # Calculate metrics
                    metrics_exp = calculate_metrics(phase_data['Average'], fit_exp, len(popt_exp))
                    metrics_log = calculate_metrics(phase_data['Average'], fit_log, len(popt_log))
                    metrics_baranyi = calculate_metrics(phase_data['Average'], fit_baranyi, len(popt_baranyi))
                    metrics_lag_exp_sat = calculate_metrics(phase_data['Average'], fit_lag_exp_sat, len(popt_lag_exp_sat))

                    # Display the metrics
                    metrics = pd.DataFrame({
                        "Model": ["Exponential", "Logistic", "Baranyi", "Lag-Exponential-Saturation"],
                        "RSS": [metrics_exp[0], metrics_log[0], metrics_baranyi[0], metrics_lag_exp_sat[0]],
                        "R-squared": [metrics_exp[1], metrics_log[1], metrics_baranyi[1], metrics_lag_exp_sat[1]],
                        "AIC": [metrics_exp[2], metrics_log[2], metrics_baranyi[2], metrics_lag_exp_sat[2]]
                    })

                    best_model_index = metrics['AIC'].idxmin()
                    best_model_name = metrics.loc[best_model_index, 'Model']
                    best_params = None
                    if best_model_name == "Exponential":
                        best_params = popt_exp
                    elif best_model_name == "Logistic":
                        best_params = popt_log
                    elif best_model_name == "Baranyi":
                        best_params = popt_baranyi
                    elif best_model_name == "Lag-Exponential-Saturation":
                        best_params = popt_lag_exp_sat

                    st.write("### Model Metrics")
                    st.write(metrics)

                    # Display the best fit parameters as a table
                    params_df = pd.DataFrame([best_params], columns=['Parameter ' + str(i+1) for i in range(len(best_params))])
                    st.write(f"### Best Fit Model: {best_model_name}")
                    st.write("### Best Fit Parameters")
                    st.write(params_df)

                    # Add the best fit model to the plot
                    if best_model_name == "Exponential":
                        fig.add_trace(go.Scatter(x=phase_data['Time'], y=fit_exp, mode='lines', name='Exponential Fit', line=dict(color='orange')))
                    elif best_model_name == "Logistic":
                        fig.add_trace(go.Scatter(x=phase_data['Time'], y=fit_log, mode='lines', name='Logistic Fit', line=dict(color='blue')))
                    elif best_model_name == "Baranyi":
                        fig.add_trace(go.Scatter(x=phase_data['Time'], y=fit_baranyi, mode='lines', name='Baranyi Fit', line=dict(color='red')))
                    elif best_model_name == "Lag-Exponential-Saturation":
                        fig.add_trace(go.Scatter(x=phase_data['Time'], y=fit_lag_exp_sat, mode='lines', name='Lag-Exponential-Saturation Fit', line=dict(color='purple')))

                    st.plotly_chart(fig)

if __name__ == "__main__":
    main()
