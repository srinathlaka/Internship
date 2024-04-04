import streamlit as st

st.set_page_config(
    page_title="Hello",
    page_icon="👋",
)

st.write("# Welcome to Growth Analyser! ⚡")

st.sidebar.success("Select a demo above.")

st.markdown(
    """
    The aim of this website is both to provide insight in the functionality of the software and justify the statistical
    approach used to analyse the growth curves coming from the plate readers **(OD vs Time)**. The process is intended to extract some biological parameters by using
    phenomenological models of growth, detailed in the following. It includes extension to any physiological model, including dynamical model via ODEs, if the model has a closed form with unknown
    parameters.
"""
)