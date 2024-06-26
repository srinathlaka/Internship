import streamlit as st
import sympy as sp
import numpy as np
import matplotlib.pyplot as plt

# Function to convert LaTeX to Python
def latex_to_function(latex_str):
    # Define the variables
    t = sp.symbols('t')
    X_0, mu = sp.symbols('X_0 mu')
    # Parse the LaTeX string
    expr = sp.sympify(latex_str)
    # Convert to a lambda function
    func = sp.lambdify((t, X_0, mu), expr, 'numpy')
    return func

# Streamlit UI
st.title("LaTeX to Python Function Converter")

# Input LaTeX string
latex_input = st.text_input("Enter the function in LaTeX (e.g., X_0*exp(mu*t)):")

# Input initial values for X_0 and mu
X_0_value = st.number_input("Enter the value for X_0:", value=1.0)
mu_value = st.number_input("Enter the value for mu:", value=1.0)

# Convert and display the function
if latex_input:
    try:
        func = latex_to_function(latex_input)
        st.write(f"Function: {latex_input}")

        # Plot the function
        t_vals = np.linspace(0, 10, 400)
        x_vals = func(t_vals, X_0_value, mu_value)

        plt.figure(figsize=(10, 6))
        plt.plot(t_vals, x_vals, label=f"${latex_input}$")
        plt.xlabel('t')
        plt.ylabel('x(t)')
        plt.title('Function Plot')
        plt.legend()
        plt.grid(True)
        st.pyplot(plt)
    except Exception as e:
        st.error(f"Error in parsing the function: {e}")

