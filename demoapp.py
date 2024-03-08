import streamlit as st
import pandas as pd
import numpy as np

st.title('Hello World')

st.header('Growth Rate Analyser')

st.header('Initial Setup')

st.text('The aim of this document is both to provide insight in the functionality of the software and justify the statistical \n'
        'approach used to analyse the growth curves coming from the plate readers (OD vs time).\n The process is intended to extract some biological parameters by using \n '
        'phenomenological models of growth, detailed in the following. It includes extension to any physiological model, including dynamical model via ODEs, if the model has a closed form with unknown \n'
        'parameters.')
st.header('Micro plate reader data')

data = pd.read_excel("C:/Users/16695/PycharmProjects/Internship/GrowthRateAnalyser2024/dataTest/test1.xlsx")

df = pd.DataFrame(data)

st.dataframe(df)
