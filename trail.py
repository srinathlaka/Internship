import matplotlib.pyplot as plt
import streamlit as st
import pandas as pd
import numpy as np
import string
from eda_plots import *

st.set_page_config(layout="wide",
                   menu_items={
                       'Get Help': 'https://www.extremelycoolapp.com/help',
                       'Report a bug': "https://www.extremelycoolapp.com/bug",
                       'About': "# developer : Srinath"
                   }
                   )
st.markdown(
    """
    <style>
    body {
        background-color: NavajoWhite;
    }
    </style>
    """,
    unsafe_allow_html=True
)
st.markdown("<div style='text-align: center;'>"
            "<h1>Growth Rate Analyser</h1>"
            "</div>", unsafe_allow_html=True)

st.markdown('<h2 style="text-align: center; color: IndianRed;"> Exploratory Data Analysis </h2>',
            unsafe_allow_html=True)

st.header('Initial Setup', divider='rainbow')

# upload the file
uploaded_file = st.file_uploader("Choose a file", type=["xlsx", "csv"])

# display the uploaded file
if uploaded_file is not None:
    # Read the uploaded file
    df = pd.read_excel(uploaded_file)
    st.write("Uploaded File:")
    st.dataframe(df, use_container_width=True)

# main code here
# Allow the user to select the number of rows and columns
rows = st.slider("Select number of rows", min_value=1, max_value=20, value=5)
columns = st.slider("Select number of columns", min_value=1, max_value=20, value=6)

column_labels = []
column_labels = ["Time"]
# Generate column labels
for col in range(1, rows + 1):
    for row in range(1, columns + 1):
        label = string.ascii_uppercase[(col - 1) % 26] + str(row)
        column_labels.append(label)
# Display the grid dimensions
st.write(f"Grid dimensions: {rows} rows x {columns} columns")

df.columns = column_labels

st.write(df, use_container_width=True)
# Display the list of button names


# List of labels
labels = column_labels[1:]
# List to store selected wells
selected_wells = set()


class SessionState(object):
    def __init__(self, **kwargs):
        for key, val in kwargs.items():
            setattr(self, key, val)


# Initialize selected wells if not already initialized
if 'selected_wells' not in st.session_state:
    st.session_state.selected_wells = set()

with st.container():
    for j in range(columns):
        cols = st.columns(rows)
        for i in range(rows):
            # Calculate the index in the labels list
            index = j + i * columns
            if index < len(labels):  # Ensure we don't go out of bounds
                button_label = labels[index]
                if button_label != "Time":  # Skip creating button for "Time" label
                    # Generate a unique key for each button using row and column indices
                    button_key = f"button_{i}_{j}"
                    if cols[i].button(button_label, key=button_key):  # Update the list when a button is clicked
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
st.write("Selected Wells:", st.session_state.selected_wells)
s_d = st.checkbox("Show standard deviation")

mean_data = df.mean(axis=1)  # Calculate mean along the columns
std_data = df.std(axis=1)  # Calculate standard deviation along the columns

st.write(df.describe())

if s_d:
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.errorbar(df['Time'], mean_data, yerr=std_data, fmt='-o', capsize=5)
    ax.set_xlabel('Time')  # Label for the x-axis
    ax.set_ylabel('Mean Measurement')  # Label for the y-axis
    ax.set_title('Mean and Standard Deviation Plot')  # Plot title
    ax.grid(True)
    st.pyplot(fig, use_container_width=True)
