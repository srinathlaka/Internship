import os

# Define folder names
script_folder = 'script'
data_rebecca_folder = 'dataRebecca'
data_ariane_folder = 'dataAriane'

# Create folders if they don't exist
os.mkdir(script_folder, exist_ok=True)
os.mkdir(data_rebecca_folder, exist_ok=True)
os.mkdir(data_ariane_folder, exist_ok=True)
