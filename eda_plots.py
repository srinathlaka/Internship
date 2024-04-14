import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
import streamlit as st


class ODDataAnalyzer:
    """Class to analyze optical density (OD) data."""

    def __init__(self, input_data):
        """
        Initialize the ODDataAnalyzer object.

        Parameters:- data (DataFrame): The raw data containing time and OD measurements.
        """
        self.data, self.x, self.y = self.add_labels_to_data(input_data)

    # @staticmethod
    def add_labels_to_data(self, input_data):
        """
        Add labels to the imported CSV file containing OD measurements.

        Parameters:
        - input_data (DataFrame): Input data containing OD measurements.

        Returns:
        - labeled_data (DataFrame): Data with labeled columns.
        """
        # Define column names with 'Time' as the first column and 'Well_i' for the rest
        column_names = ['Time'] + [f'Well_{i}' for i in range(1, len(input_data.columns))]

        # Assign column names to the input data
        input_data.columns = column_names

        x = input_data['Time']
        y = input_data.iloc[:, 1:]

        # Return the input data with labeled columns
        return input_data, x, y

    def plot_data(self, x, y):
        """
        Plot optical density data.

        Parameters:
        - x (array-like): Independent variable (e.g., time).
        - y (array-like): Dependent variable (e.g., optical density).

        Returns:
        - None
        """
        # Create a figure and axis with specific size
        fig, ax = plt.subplots(figsize=(10, 6))

        # Plot the data with blue color and label
        for column in self.data.columns[1:]:
            ax.plot(x, y[column], label=column)

        # Set labels for x and y axes
        ax.set_xlabel('Time(seconds)')
        ax.set_ylabel('Optical Density')

        # Set the title of the plot
        ax.set_title('OD vs Time Plot')

        # Display the legend and show the plot
        ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.1), ncol=4)
        plt.show()

    def histogram_plot(self, well_column, df):
        """
        Plot a histogram of a specific well's optical density data.
        """
        plt.hist(df[well_column], bins=20)
        plt.xlabel('Measurement')
        plt.ylabel('Frequency')
        plt.title(f'Distribution of Measurements for {well_column}')
        plt.show()

    def col(self):
        col1, col2, col3 = st.columns([1, 3, 1])


def create_grid_app():
    """
  This function creates a Streamlit app with a grid of buttons and stores button names.
  """

    # Allow user to select grid dimensions
    rows = st.slider("Select number of rows", min_value=1, max_value=20, value=5)
    columns = st.slider("Select number of columns", min_value=1, max_value=20, value=6)

    # Function to generate column labels
    def generate_column_label(index):
        dividend = index + 1
        column_label = ''
        while dividend > 0:
            modulo = (dividend - 1) % 26
            column_label = chr(65 + modulo) + column_label
            dividend = (dividend - modulo) // 26
        return column_label

    # Create empty list to store button names
    button_names = []

    # Create nested loop for grid and button name storage
    for i in range(rows):
        cols = st.columns(columns)
        for j in range(columns):
            column_label = generate_column_label(j)
            button_label = f'{column_label}{i + 1}'
            if cols[j].button(button_label):
                fig, ax = plt.subplots()
                ax.plot("Time", cols[j], label=button_label)
                plt.show()# Assuming plot_data(data) handles button clicks
                st.pyplot(fig)
            button_names.append(button_label)

    return button_names


def generate_labels(rows, cols):
    """
    Generates a list of labels for a grid with the specified rows and columns.

    Args:
        rows: The number of rows in the grid.
        cols: The number of columns in the grid.

    Returns:
        A list of labels in the format "A1", "A2", ..., "B1", "B2", ..., "Zn"
        where n is the total number of cells (rows * cols).
    """
    labels = []
    total_cells = rows * cols
    for i in range(total_cells):
        label = chr(ord('A') + i // cols) + str(i % cols + 1)
        labels.append(label)
    return labels
