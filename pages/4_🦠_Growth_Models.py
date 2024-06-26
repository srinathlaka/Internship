import streamlit as st

def app():
    st.title("Bacterial Growth Models")

    st.write("## Exponential Growth Model")
    st.write("The exponential growth model is described by the following equations:")
    st.latex(r'''
        \frac{dX}{dt} = \mu X
    ''')
    st.latex(r'''
        x(t) = X_0 e^{\mu t}
    ''')
    st.code("""
def exponential_growth(t, mu, X0):
    return X0 * np.exp(mu * t)
    """)

    st.write("## Logistic Growth Model")
    st.write("The logistic growth model with saturation is described by the following equations:")
    st.latex(r'''
        \frac{dX}{dt} = \mu X \left(1 - \frac{X}{K}\right)
    ''')
    st.latex(r'''
        x(t) = \frac{X_0 e^{\mu t}}{1 + \frac{X_0}{K} \left(e^{\mu t} - 1\right)}
    ''')
    st.code("""
def logistic_growth(t, mu, X0, K):
    return (X0 * np.exp(mu * t)) / (1 + (X0 / K) * (np.exp(mu * t) - 1))
    """)

    st.write("## Baranyi Model")
    st.write("The Baranyi model for lag-exponential growth is described by the following equations:")
    st.latex(r'''
        \frac{dX}{dt} = \mu \frac{q(t)}{1 + q(t)} X
    ''')
    st.latex(r'''
        \frac{dq}{dt} = \mu q
    ''')
    st.latex(r'''
        x(t) = X_0 \frac{1 + q_0 e^{\mu t}}{1 + q_0}
    ''')
    st.code("""
def baranyi_growth(t, X0, mu, q0):
    q_t = q0 * np.exp(mu * t)
    return X0 * (1 + q_t) / (1 + q0)
    """)

    st.write("## Lag-Exponential-Saturation Growth Model")
    st.write("The lag-exponential-saturation growth model is described by the following equations:")
    st.latex(r'''
        \frac{dX}{dt} = \mu \frac{q(t)}{1 + q(t)} X \left(1 - \frac{X}{K}\right)
    ''')
    st.latex(r'''
        \frac{dq}{dt} = \mu q
    ''')
    st.latex(r'''
        x(t) = X_0 \frac{1 + q_0 e^{\mu t}}{1 + q_0 - q_0 \frac{X_0}{K} + \frac{q_0 X_0}{K} e^{\mu t}}
    ''')
    st.code("""
def lag_exponential_saturation_growth(t, mu, X0, q0, K):
    return X0 * (1 + q0 * np.exp(mu * t)) / (1 + q0 - q0 * (X0 / K) + (q0 * X0 / K) * np.exp(mu * t))
    """)

if __name__ == "__main__":
    app()
