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
        # **Fix here:** Add this line only if df exists after reading the file
        if df is not None:  # Check if df is defined
            # labeling the data
            rows = st.slider("Select number of rows", min_value=1, max_value=20, value=5)
            columns = st.slider("Select number of columns", min_value=1, max_value=20, value=6)
            labels = generate_labels(rows, columns)
            column_labels = ["Time"] + labels  # Add time as first column
            # Display the grid dimensions
            st.write(f"Grid dimensions: {rows} rows x {columns} columns")

            df.columns = column_labels
            # df.dropna(axis=1, inplace=True)

            st.write(df)

            # Display the list of button names

            # List of labels
            labels = column_labels[1:]
            # List to store selected wells
            selected_wells = set()

            class SessionState(object):
                def __init__(self, **kwargs):
                    for key, val in kwargs.items():
                        setattr(self, key, val)

            # Display the selected wells
            selected_wells_message = st.empty()  # Placeholder to display selected wells

            # Initialize selected wells if not already initialized
            if 'selected_wells' not in st.session_state:
                st.session_state.selected_wells = set()

            with st.container():
                for i in range(rows):
                    cols = st.columns(columns)
                    for j in range(columns):
                        # Calculate the index in the labels list
                        index = i * columns + j
                        if index < len(labels):  # Ensure we don't go out of bounds
                            button_label = labels[index]
                            if button_label != "Time":  # Skip creating button for "Time" label
                                # Generate a unique key for each button using row and column indices
                                button_key = f"button_{i}_{j}"
                                if cols[j].button(button_label, key=button_key):  # Update the list when a button is clicked
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

            # Display the selected wells
            selected_wells_text = f"Selected Wells: {st.session_state.selected_wells}"
            selected_wells_message.write(selected_wells_text)

        def clear_selected_wells():
            st.session_state.selected_wells.clear()
            selected_wells_message.warning("Selected wells cleared.")

        # Display the clear button
        if st.button("Clear selected wells"):
            clear_selected_wells()

        # Display the selected wells
        selected_wells_text = f"Selected Wells: {st.session_state.selected_wells}"
        selected_wells_message.write(selected_wells_text)

        plots = st.checkbox("check the box below to compare the plots of selected wells")

        if plots:
            fig, ax = plt.subplots(figsize=(8, 5))
            x = df["Time"]
            y = df[list(st.session_state.selected_wells)]
            ax.plot(x, y)
            ax.set_title(f"Time vs Slected well's OD")
            ax.legend([str(i) for i in list(st.session_state.selected_wells)], loc='upper right')
            st.pyplot(fig=fig)

        df.dropna(axis=1, inplace=True)

        mean_data = df.mean(axis=1)  # Calculate mean along the columns
        std_data = df.std(axis=1)  # Calculate standard deviation along the columns

        average = st.checkbox("Check the box to view average of the selected wells")

        if average and len(st.session_state.selected_wells) > 0:
            mean = df[list(st.session_state.selected_wells)].mean(axis=1)
            st.write(mean)

            plt.plot(df['Time'], mean, label='Average Measurement')
            plt.xlabel('Time')  # Label for the x-axis
            plt.ylabel('Average Measurement')  # Label for the y-axis
            plt.title('Average Measurement for Selected Wells Over Time')  # Plot title
            plt.grid(True)
            st.pyplot()

        s_d = st.checkbox("Show standard deviation")

        if s_d and len(st.session_state.selected_wells) > 0:
            std = df[list(st.session_state.selected_wells)].std().sort_values()
            fig, ax = plt.subplots(figsize=(10, 6))
            ax.errorbar(std.index, [0] * len(std), yerr=std, fmt='o', color='b', markersize=8, capsize=5)
            ax.set_xticks(range(len(std)))
            ax.set_xticklabels(std.index, rotation=45)
            ax.set_ylabel('Standard Deviation')
            ax.set_title('Standard Deviation of Selected Wells')
            ax.grid(True, linestyle='--', alpha=0.6)
            st.pyplot(fig)

    except FileNotFoundError:
        st.error("File not found. Please upload a valid file.")
    except Exception as e:
        st.error(f"Error: {e}")
else:
    st.write("Please upload a file.")
