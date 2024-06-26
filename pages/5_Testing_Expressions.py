import streamlit as st
from sympy import Symbol
from latex2sympy2 import latex2sympy

# Function to evaluate LaTeX input
def evaluate_latex(latex_func, x_val):
    x = Symbol('x')
    try:
        sympy_expr = latex2sympy(latex_func)
        result = sympy_expr.subs(x, x_val)
        return result
    except Exception as e:
        return f"Error: {str(e)}"

# Tips for writing LaTeX
latex_tips = """
### Tips for writing LaTeX:
1. Use `x` for the variable.
2. Use `^` for exponents, e.g., `x^2`.
3. Use `{}` for grouping, e.g., `x^{2}`.
4. Use `\\frac{numerator}{denominator}` for fractions.
5. Use `\\sqrt{expression}` for square roots.
6. Use standard mathematical functions like `\\sin`, `\\cos`, `\\log`, etc.
"""

# Create the Streamlit app
def main():
    st.title("LaTeX Function Evaluator")
    st.write("Enter a LaTeX function and a value for x to evaluate the function.")
    
    st.write(latex_tips)

    # User input for LaTeX function
    latex_func = st.text_input("Enter the LaTeX function (e.g., x^2 + 2x + 1):", value="x^2 + 2x + 1")

    # User input for the value of x
    x_val = st.number_input("Enter a value for x:", value=0.0)

    # Display the LaTeX function
    if latex_func:
        st.write("### LaTeX Function:")
        st.latex(latex_func)
        
        # Evaluate the function
        result = evaluate_latex(latex_func, x_val)
        st.write(f"### Result: f({x_val}) = {result}")

if __name__ == "__main__":
    main()
