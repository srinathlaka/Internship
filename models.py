import numpy as np
from scipy.optimize import curve_fit
import streamlit as st



# Saturation growth model
def saturation_growth_model(x, a, k0, b):
    """Saturation growth model function."""
    return a * x / (x + k0) + b

# Repression growth model
def repression_growth_model(x, a, k0, b):
    """Repression growth model function."""
    return a / (k0 * x + k0) + b

def fit_polynomial_growth(data_x, data_y, n_guess):
    """Fit polynomial growth model to data."""
    p = np.polyfit(data_x, data_y, n_guess)
    return p





def fit_saturation_growth(data_x, data_y):
    """Fit saturation growth model to data."""
    try:
        popt, _ = curve_fit(saturation_growth_model, data_x, data_y)
        y_pred = saturation_growth_model(data_x, *popt)  # Calculate the predicted values
        return popt, np.array(y_pred).flatten()  # Convert to NumPy array and flatten
    except RuntimeError:
        print("Optimal parameters could not be found. Check if the input data is suitable.")

def fit_repression_growth(data_x, data_y):
    """Fit repression growth model to data."""
    try:
        popt, _ = curve_fit(repression_growth_model, data_x, data_y)
        y_pred = repression_growth_model(data_x, *popt)  # Calculate the predicted values
        return popt, np.array(y_pred).flatten()  # Convert to NumPy array and flatten
    except RuntimeError:
        print("Optimal parameters could not be found. Check if the input data is suitable.")




