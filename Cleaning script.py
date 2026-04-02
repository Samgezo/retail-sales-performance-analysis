import pandas as pd

# Read with latin-1 to handle special characters
df = pd.read_csv(
    r'C:\Users\drago\OneDrive\Desktop\Job Hunt\SQL\Project-1-Retail-Sales-Analysis\data\raw\Sample - Superstore.csv',
    encoding='latin-1'
)

# Confirm it loaded
print(f"Rows: {df.shape[0]}")
print(f"Columns: {df.shape[1]}")
print(df.columns.tolist())

# --- CLEANING STEP ---
# Some product names contain commas or quotes which break CSV imports
# This loops through every text column and removes problematic characters
for col in df.select_dtypes(include='object').columns:
    df[col] = df[col].astype(str).str.replace('"', '', regex=False)
    df[col] = df[col].str.replace("'", '', regex=False)
    df[col] = df[col].str.strip()

# Save clean version with quoting set to QUOTE_NONE equivalent
# quoting=1 means QUOTE_ALL - wraps every field safely
df.to_csv(r'C:\Users\drago\OneDrive\Desktop\Job Hunt\SQL\Project-1-Retail-Sales-Analysis\data\cleaned\superstore_clean.csv',
    index=False,
    encoding='utf-8',
    quoting=1  # Forces ALL fields to be quoted consistently
)

print("Clean file saved successfully!")

## What Changed and Why

#The original error happened because a product name like this was in the data:
#"Cisco TelePresence System, "Classic" Edition"