import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
from eda_plots import generate_labels  # Import the generate_labels function

def upload_file():
    uploaded_file = st.file_uploader("Choose a file", type=["xlsx", "csv"])
    return uploaded_file

def read_data(uploaded_file):
    if uploaded_file is not None:
        try:
            st.success("File uploaded successfully!")
            df = pd.read_excel(uploaded_file, header=None)  # Read data
            return df
        except Exception as e:
            st.error(f"Error: {e}")
    return None

def select_layout():
    layout_option = st.selectbox("Select layout option", ["Select from presets", "Custom"])
    if layout_option == "Select from presets":
        well_format = st.selectbox("Select well format", ["24 well rows 4 column 6", 
                                                         "96 well rows 8 column 12",
                                                         "12 well rows 3 column 4",
                                                         "1536 well rows 32 column 48"])
        if well_format == "24 well rows 4 column 6":
            return 4, 6
        elif well_format == "96 well rows 8 column 12":
            return 8, 12
        elif well_format == "12 well rows 3 column 4":
            return 3, 4
        elif well_format == "1536 well rows 32 column 48":
            return 32, 48
    else:  # Custom layout
        custom_rows = st.number_input("Enter number of rows", min_value=1, step=1)
        custom_columns = st.number_input("Enter number of columns", min_value=1, step=1)
        return int(custom_rows), int(custom_columns)

def select_wells(df, rows, columns, labels, session_key):
    if session_key not in st.session_state:
        st.session_state[session_key] = set()

    selected_wells = st.session_state[session_key]

    with st.container():
        for i in range(rows):
            cols = st.columns(columns)
            for j in range(columns):
                index = i * columns + j
                if index < len(labels):
                    button_label = labels[index]
                    if button_label != "Time":
                        well_label = f"{chr(65+i)}{j+1}"  # Generate well label (e.g., A1, B2)
                        button_key = f"button_{i}_{j}_{well_label}"  # Unique key
                        if cols[j].button(button_label, key=button_key):
                            if well_label in selected_wells:
                                selected_wells.remove(well_label)
                            else:
                                selected_wells.add(well_label)

    st.session_state[session_key] = selected_wells
    return selected_wells


def clear_selected_wells(session_key):
    st.session_state[session_key].clear()

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

def main():
    st.set_page_config(page_title="Exploratory Data Analysis", page_icon="📊")
    st.markdown("# Exploratory Data Analysis")
    st.sidebar.header("Exploratory Data Analysis")
    st.write("""Please upload the files in .xlsx or .csv format only""")
    
    uploaded_file = upload_file()
    if uploaded_file is not None:
        df = read_data(uploaded_file)
        if df is not None:
            rows, columns = select_layout()
            labels = generate_labels(rows, columns)
            df.columns = ["Time"] + labels
            st.write(df)

            selected_blank_wells = select_wells(df, rows, columns, labels, "selected_blank_wells")
            selected_sample_replicates = select_wells(df, rows, columns, labels, "selected_sample_replicates")

            clear_blank_wells_button = st.button("Clear selected blank wells")
            if clear_blank_wells_button:
                clear_selected_wells("selected_blank_wells")

            clear_sample_replicates_button = st.button("Clear selected sample replicates")
            if clear_sample_replicates_button:
                clear_selected_wells("selected_sample_replicates")

            if st.button("Perform Background Subtraction"):
                # Perform background subtraction here
                pass

            plots = st.checkbox("Check the box below to compare the plots of selected wells")
            if plots:
                plot_selected_wells(df, st.session_state.selected_blank_wells | st.session_state.selected_sample_replicates)

            average = st.checkbox("Check the box to view the average of the selected wells")
            if average:
                plot_average(df, st.session_state.selected_blank_wells | st.session_state.selected_sample_replicates)

if __name__ == "__main__":
    main()
