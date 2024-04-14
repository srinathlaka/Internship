import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
from eda_plots import generate_labels  # Import the generate_labels function

st.set_page_config(page_title="Exploratory Data Analysis", page_icon="📊")

st.markdown("# Exploratory Data Analysis")
st.sidebar.header("Exploratory Data Analysis")
st.write("""Please upload the files in .xlsx or .csv format only""")

uploaded_file = st.file_uploader("Choose a file", type=["xlsx", "csv"])

# Check if a file is uploaded
if uploaded_file is not None:
    try:
        st.success("File uploaded successfully!")
        df = pd.read_excel(uploaded_file, header=None)  # Read data
        
        if df is not None:  # Check if df is defined
            layout_option = st.selectbox("Select layout option", ["Select from presets", "Custom"])
            
            if layout_option == "Select from presets":
                well_format = st.selectbox("Select well format", ["24 well rows 4 column 6", 
                                                                 "96 well rows 8 column 12",
                                                                 "12 well rows 3 column 4",
                                                                 "1536 well rows 32 column 48"])
                
                if well_format == "24 well rows 4 column 6":
                    rows, columns = 4, 6
                elif well_format == "96 well rows 8 column 12":
                    rows, columns = 8, 12
                elif well_format == "12 well rows 3 column 4":
                    rows, columns = 3, 4
                elif well_format == "1536 well rows 32 column 48":
                    rows, columns = 32, 48
            else:  # Custom layout
                custom_rows = st.number_input("Enter number of rows", min_value=1, step=1)
                custom_columns = st.number_input("Enter number of columns", min_value=1, step=1)
                rows, columns = int(custom_rows), int(custom_columns)
            labels = generate_labels(rows, columns)
            column_labels = ["Time"] + labels  # Add time as first column
            
            st.write(f"Grid dimensions: {rows} rows x {columns} columns")

            df.columns = column_labels
            st.write(df)

            labels = column_labels[1:]
            selected_wells = set()

            class SessionState(object):
                def __init__(self, **kwargs):
                    for key, val in kwargs.items():
                        setattr(self, key, val)

            selected_wells_message = st.empty()

            if 'selected_wells' not in st.session_state:
                st.session_state.selected_wells = set()

            with st.container():
                for i in range(rows):
                    cols = st.columns(columns)
                    for j in range(columns):
                        index = i * columns + j
                        if index < len(labels):
                            button_label = labels[index]
                            if button_label != "Time":
                                button_key = f"button_{i}_{j}"
                                if cols[j].button(button_label, key=button_key):
                                    fig, ax = plt.subplots(figsize=(10, 6))
                                    ax.plot(df["Time"], df[button_label])
                                    ax.set_title(f"Time vs OD of {button_label}")
                                    col1, col2, col3 = st.columns(3)
                                    with col2:
                                        st.pyplot(fig, use_container_width=True)
                                    if button_label in selected_wells:
                                        st.session_state.selected_wells.remove(button_label)
                                    else:
                                        st.session_state.selected_wells.add(button_label)

            selected_wells_text = f"Selected Wells: {st.session_state.selected_wells}"
            selected_wells_message.write(selected_wells_text)

        def clear_selected_wells():
            st.session_state.selected_wells.clear()
            selected_wells_message.warning("Selected wells cleared.")

        if st.button("Clear selected wells"):
            clear_selected_wells()

        selected_wells_text = f"Selected Wells: {st.session_state.selected_wells}"
        selected_wells_message.write(selected_wells_text)

        plots = st.checkbox("Check the box below to compare the plots of selected wells")

        if plots:
            fig, ax = plt.subplots(figsize=(8, 5))
            x = df["Time"]
            y = df[list(st.session_state.selected_wells)]
            ax.plot(x, y)
            ax.set_title(f"Time vs Selected well's OD")
            ax.legend([str(i) for i in list(st.session_state.selected_wells)], loc='upper right')
            st.pyplot(fig=fig)

        df.dropna(axis=1, inplace=True)

        average = st.checkbox("Check the box to view the average of the selected wells")

        if average and len(st.session_state.selected_wells) > 0:
            selected_wells_list = list(st.session_state.selected_wells)
            df['Average'] = df[selected_wells_list].mean(axis=1)
            fig, ax = plt.subplots(figsize=(10, 6))
            ax.plot(df['Time'], df['Average'], label='Average Measurement')
            ax.set_xlabel('Time')
            ax.set_ylabel('Average Measurement')
            ax.set_title('Average Measurement for Selected Wells Over Time')
            ax.grid(True)
            st.pyplot(fig)

            

        std_deviation = st.checkbox("Check the box to view standard deviation of the selected wells")

        if std_deviation and len(st.session_state.selected_wells) > 0:
            std = df[list(st.session_state.selected_wells)].std().sort_values()
            fig, ax = plt.subplots(figsize=(10, 6))
            ax.errorbar(std.index, [0] * len(std), yerr=std, fmt='o', color='b', markersize=8, capsize=5)
            ax.set_xticks(range(len(std)))
            ax.set_xticklabels(std.index, rotation=45)
            ax.set_ylabel('Standard Deviation')
            ax.set_title('Standard Deviation of Selected Wells')
            ax.grid(True, linestyle='--', alpha=0.6)
            st.pyplot(fig)

        std_deviation_percentage = st.checkbox("Check the box to view standard deviation as a percentage of average.")

        if std_deviation_percentage and len(st.session_state.selected_wells) > 0:
            selected_wells_list = list(st.session_state.selected_wells)
            mean_data_selected = df[selected_wells_list].mean(axis=1)
            std_data_selected = df[selected_wells_list].std(axis=1)

            fig, ax = plt.subplots(figsize=(10, 6))
            for col in selected_wells_list:
                ax.plot(df['Time'], df[col], label=col)

            ax.errorbar(df['Time'], mean_data_selected, yerr=std_data_selected, fmt='o', color='black', label='Average ± Std. Deviation')

            ax.set_xlabel('Time')
            ax.set_ylabel('Measurement')
            ax.set_title('Average and Standard Deviation Plot for Selected Wells')
            ax.legend()
            st.pyplot(fig)

    except FileNotFoundError:
        st.error("File not found. Please upload a valid file.")
    except Exception as e:
        st.error(f"Error: {e}")
else:
    st.write("Please select a file to upload.")
