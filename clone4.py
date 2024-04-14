import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
from eda_plots import generate_labels  # Import the generate_labels function
from models import *



def upload_file():
    uploaded_file = st.file_uploader("Choose a file", type=["xlsx", "csv"])
    return uploaded_file

def read_data(uploaded_file, rows, columns):
    if uploaded_file is not None:
        try:
            st.success("File uploaded successfully!")
            df = pd.read_excel(uploaded_file, header=None)  # Read data
            # Ensure the DataFrame has the desired layout
            df = adjust_dataframe_layout(df, rows, columns)
            return df
        except Exception as e:
            st.error(f"Error: {e}")
    return None


def adjust_dataframe_layout(df, rows, columns):
    # Ensure the DataFrame has the desired number of rows and columns
    if df.shape[0] < rows or df.shape[1] < columns:
        # Create a new DataFrame with the desired number of rows and columns
        new_df = pd.DataFrame(index=range(rows), columns=range(columns))
        # Fill the new DataFrame with the values from the uploaded DataFrame
        new_df.iloc[:df.shape[0], :df.shape[1]] = df.values
        # Fill remaining cells with NaN values
        new_df.iloc[df.shape[0]:, df.shape[1]:] = np.nan
        return new_df
    else:
        return df



def plot_fitted_curves(df, model, parameters):
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.plot(df['Time'], df['Average'], label='Observed Data')

    if model == 'Polynomial':
        y_pred = np.polyval(parameters, df['Time'])
    elif model == 'Saturation':
        y_pred = saturation_growth_model(df['Time'], *parameters)
    elif model == 'Repression':
        y_pred = repression_growth_model(df['Time'], *parameters)
    else:
        st.warning("Invalid model type. Supported models are 'Polynomial', 'Saturation', and 'Repression'.")
        return

    ax.plot(df['Time'], y_pred, label='Fitted Curve', color='red')
    
    ax.set_xlabel('Time')
    ax.set_ylabel('OD')
    ax.set_title('Fitted Growth Model')
    ax.legend()
    ax.grid(True)
    
    st.pyplot(fig)

    # Display the shapes of df['Time'] and y_pred
    st.write("Shape of df['Time']:", df['Time'].shape)
    st.write("Shape of y_pred:", y_pred.shape)



def fit_growth_model(model_type, data_x, data_y):
    """Fit selected growth model to data."""
    if model_type == "Polynomial":
        # Degree of the polynomial growth model
        n_guess = 10  # or any other value for the degree
        return fit_polynomial_growth(data_x, data_y, n_guess)
    elif model_type == "Saturation":
        n_guess = 2
        return fit_saturation_growth(data_x, data_y)
    elif model_type == "Repression":
        # Provide initial guesses for parameters if needed
        n_guess = 2
        return fit_repression_growth(data_x, data_y)
    else:
        raise ValueError("Invalid model type")



def plot_avg_and_std(df, selected_wells, y_pred=None, std_dev=None, log_scale=False):
    if len(selected_wells) > 0:
        selected_wells_list = list(selected_wells)
        df['Average'] = df[selected_wells_list].mean(axis=1)
        if std_dev is not None:
            df['Std Dev'] = df[selected_wells_list].std(axis=1)
        
        fig, ax = plt.subplots(figsize=(10, 6))
        
        if log_scale:
            ax.set_yscale('log')  # Set y-axis scale to logarithmic if log_scale is True
        
        ax.plot(df['Time'], df['Average'], label='Average Measurement')
        
        if y_pred is not None:
            ax.plot(df['Time'], y_pred, label='Fitted Curve', color='red')
        
        if std_dev is not None:
            ax.fill_between(df['Time'], df['Average'] - std_dev, df['Average'] + std_dev, color='green', alpha=0.3, label='Standard Deviation')
        
        ax.set_xlabel('Time')
        ax.set_ylabel('Average Measurement')
        ax.set_title('Average Measurement with Standard Deviation')
        ax.grid(True)
        ax.legend()
        st.pyplot(fig)



def plot_selected_wells(df, selected_wells):
    fig, ax = plt.subplots(figsize=(8, 5))
    x = df["Time"]
    y = df[list(selected_wells)]
    ax.plot(x, y)
    ax.set_title(f"Time vs Selected well's OD")
    ax.legend([str(i) for i in list(selected_wells)], loc='upper right')
    st.pyplot(fig=fig)

def plot_average(df, selected_wells):
    if len(selected_wells) > 0:
        selected_wells_list = list(selected_wells)
        df['Average'] = df[selected_wells_list].mean(axis=1)
        fig, ax = plt.subplots(figsize=(10, 6))
        ax.plot(df['Time'], df['Average'], label='Average Measurement')
        ax.set_xlabel('Time')
        ax.set_ylabel('Average Measurement')
        ax.set_title('Average Measurement for Selected Wells Over Time')
        ax.grid(True)
        st.pyplot(fig)


def select_layout():
    layout_option = st.selectbox("Select layout option", ["Select from presets", "Custom"])
    if layout_option == "Select from presets":
        well_format = st.selectbox("Select well format", ["24 well rows 4 column 6", 
                                                         "96 well rows 8 column 12",
                                                         "84 well rows 7 column 12",
                                                         "1536 well rows 32 column 48"])
        if well_format == "24 well rows 4 column 6":
            return 4, 6
        elif well_format == "96 well rows 8 column 12":
            return 8, 12
        elif well_format == "84 well rows 7 column 12":
            return 7, 12
        elif well_format == "1536 well rows 32 column 48":
            return 32, 48
    else:  # Custom layout
        custom_rows = st.number_input("Enter number of rows", min_value=1, step=1)
        custom_columns = st.number_input("Enter number of columns", min_value=1, step=1)
        return int(custom_rows), int(custom_columns)

def select_wells(df, rows, columns, labels, message, session_key):
    if session_key not in st.session_state:
        st.session_state[session_key] = set()

    selected_wells = sorted(list(st.session_state[session_key]))  # Sort the selected wells

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
                            selected_wells = sorted(selected_wells)  # Sort the selected wells after adding/removing
                            st.session_state[session_key] = set(selected_wells)

    selected_wells_text = f"Currently Selected Wells: " + ", ".join(selected_wells) if selected_wells else "None"
    message.write(selected_wells_text)

    return selected_wells





def clear_selected_wells(session_key, message):
    st.session_state[session_key].clear()
    message.warning("Selected wells cleared.")

def perform_background_subtraction(df, selected_blank_wells, selected_sample_replicates, y_pred):
    if len(selected_blank_wells) == 0 or len(selected_sample_replicates) == 0:
        st.warning("Please select both blank wells and sample replicates for subtraction.")
        return None
    
    # Convert set to list
    selected_blank_wells_list = list(selected_blank_wells)
    
    # Calculate the mean value of blank wells
    blank_mean = df[selected_blank_wells_list].mean(axis=1)
    
    # Perform background subtraction
    for sample_replicate in selected_sample_replicates:
        df[sample_replicate] = df[sample_replicate] - y_pred  # Subtract the fitted curve values
    
    return df


#rows, columns = select_layout()

def main():
    st.set_page_config(page_title="Exploratory Data Analysis", page_icon="📊")
    st.markdown("# Exploratory Data Analysis")
    st.sidebar.header("Exploratory Data Analysis")
    st.write("""Please upload the files in .xlsx or .csv format only""")
    rows, columns = select_layout()
    uploaded_file = upload_file()
    if uploaded_file is not None:
        df = read_data(uploaded_file, rows, columns)
        if df is not None:
            try:
                labels = generate_labels(rows, columns)
                st.write(f"Grid dimensions: {rows} rows x {columns} columns")
                df.columns = ["Time"] + labels
                st.write(df)
            except ValueError as ve:
                st.error(f"Error: {ve}")
                # Print the length of labels list
                st.write(f"Length of labels list: {len(labels)}")
                # Print the number of columns in DataFrame
                st.write(f"Number of columns in DataFrame: {df.shape[1]}")
                return  # Exit the function if ValueError occurs

            selected_blank_wells_message = st.empty()
            selected_blank_wells = select_wells(df, rows, columns, labels, selected_blank_wells_message, "selected_blank_wells")

            std_dev_blank_cells = df[selected_blank_wells].std(axis=1)
            
            plots_before_bg_subtraction = st.checkbox("Check the box below to compare the plots of selected blank wells")
            if plots_before_bg_subtraction:
                plot_selected_wells(df, selected_blank_wells)

            average_blank_cells = st.checkbox("Check the box to view the average of the selected blank wells")
            if average_blank_cells:
                plot_average(df, selected_blank_wells)
                fit_average = st.checkbox("Fit average")
                if fit_average is True:
                    selected_model = st.selectbox("Select growth model", ["Polynomial", "Saturation", "Repression"], key="fit_average")
                    if selected_model:
                        st.write("Fit of the average blank cells")
                        popt = fit_growth_model(selected_model, df['Time'], df['Average'])
                        st.write("Parameter values (popt):", popt)  # Add this line to print out popt
                        # Calculate y_pred based on the selected growth model and its parameters
                        if selected_model == "Polynomial":
                            y_pred = np.polyval(popt, df['Time'])
                        elif selected_model == "Saturation":
                            popt, y_pred = fit_saturation_growth(df['Time'], df['Average'])
                        elif selected_model == "Repression":
                            y_pred = fit_repression_growth(df['Time'], df['Average'])

                        plot_fitted_curves(df, selected_model, popt)

                        # Plot the fitted curve alongside the average and standard deviation plot
                        plot_avg_and_std(df, selected_blank_wells, y_pred, std_dev_blank_cells)
                        log_scale = st.checkbox("Plot on logarithmic scale")
                        plot_avg_and_std(df, selected_blank_wells, y_pred, std_dev_blank_cells, log_scale=log_scale)


            clear_blank_wells_button = st.button("Clear selected blank wells")
            if clear_blank_wells_button:
                clear_selected_wells("selected_blank_wells", selected_blank_wells_message)

            selected_sample_replicates_message = st.empty()
            selected_sample_replicates = select_wells(df, rows, columns, labels, selected_sample_replicates_message, "selected_sample_replicates")

            clear_sample_replicates_button = st.button("Clear selected sample replicates")
            if clear_sample_replicates_button:
                clear_selected_wells("selected_sample_replicates", selected_sample_replicates_message)
            Perform_Background_Subtraction = st.checkbox("Check the box below to perform background subtraction")
            if Perform_Background_Subtraction is True:
                df_bg_subtracted = perform_background_subtraction(df.copy(), selected_blank_wells, selected_sample_replicates, y_pred)
                if df_bg_subtracted is not None:
                    st.success("Background subtraction completed successfully!")
                    st.write(df_bg_subtracted)

                    selected_wells = st.session_state.selected_sample_replicates
                    plot_selected_wells(df_bg_subtracted, selected_wells)

                    plot_average(df_bg_subtracted, selected_wells)

                    #plot_avg_and_std(df_bg_subtracted, selected_wells)

                    fit_growth = st.checkbox("Fit Growth Model")

                    if fit_growth is True:
                        selected_model = st.selectbox("Select growth model", ["Polynomial", "Saturation", "Repression"])
                        if selected_model:
                            if 'Average' in df_bg_subtracted.columns:  # Check if 'Average' column exists
                                popt = fit_growth_model(selected_model, df_bg_subtracted['Time'], df_bg_subtracted['Average'])
                                st.write("Parameter values (popt):", popt)  # Add this line to print out popt
                                # Plot the fitted curve alongside the observed data
                                plot_fitted_curves(df_bg_subtracted, selected_model, popt)
                            else:
                                st.warning("Please perform background subtraction first.")
                        else:
                            st.warning("Please select a growth model.")
            

            


if __name__ == "__main__":


    main()


