#IMPORTING LIBRARIES
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
plt.style.use("default")

#LOADIING DATAS
customer = pd.read_csv(
    "/home/sanjay/Downloads/archive/customer_dim.csv",
    encoding="latin1"
)
fact = pd.read_csv("/home/sanjay/Downloads/archive/fact_table.csv",encoding="latin1")
item = pd.read_csv("/home/sanjay/Downloads/archive/item_dim.csv",encoding="latin1")
store = pd.read_csv("/home/sanjay/Downloads/archive/store_dim.csv",encoding="latin1")
time = pd.read_csv("/home/sanjay/Downloads/archive/time_dim.csv",encoding="latin1")
trans = pd.read_csv("/home/sanjay/Downloads/archive/trans_dim.csv",encoding="latin1")

#TRANSFORMING COLUMNS
def clean_columns(df):
    df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
    )
    return df
fact = clean_columns(fact)
customer = clean_columns(customer)
item = clean_columns(item)
store = clean_columns(store)
time = clean_columns(time)
trans = clean_columns(trans)

#TRANSFORMING DATATYPES
fact["quantity"] = pd.to_numeric(fact["quantity"], errors="coerce")
fact["unit_price"] = pd.to_numeric(fact["unit_price"], errors="coerce")

#CHANGING DATE FORMAT
time["date"] = pd.to_datetime(
    time["date"],
    dayfirst=True,
    errors="coerce"
)

#REMOVING EMPTY ROWS
fact.dropna(subset=["quantity", "unit_price"], inplace=True)

#REMOVING DUPLICATES
fact.drop_duplicates(inplace=True)
customer.drop_duplicates(inplace=True)
item.drop_duplicates(inplace=True)
store.drop_duplicates(inplace=True)
time.drop_duplicates(inplace=True)
trans.drop_duplicates(inplace=True)

#CHECKING ERRORS
assert fact["coustomer_key"].notnull().all()
assert customer["coustomer_key"].is_unique
assert item["item_key"].is_unique
assert store["store_key"].is_unique
assert time["time_key"].is_unique
assert trans["payment_key"].is_unique

#CLEANING TEXTS
text_cols = ["item_name", "desc", "supplier"]

for col in text_cols:
    if col in item.columns:
        item[col] = (
            item[col]
            .astype(str)
            .str.strip()
            .str.replace(r"[^\x00-\x7F]+", "", regex=True)
        )


#CREATING REVENUE COLUMN
fact["revenue"] = fact["quantity"] * fact["unit_price"]

#CREATING SCHEMA
df = (
    fact
    .merge(customer, on="coustomer_key", how="left")
    .merge(item, on="item_key", how="left")
    .merge(store, on="store_key", how="left")
    .merge(time, on="time_key", how="left")
    .merge(trans, on="payment_key", how="left")
)

#KPI's
total_revenue = df["revenue"].sum()
total_transactions = df["payment_key"].nunique()
total_customers = df["coustomer_key"].nunique()
aov = total_revenue / total_transactions

total_revenue, total_transactions, total_customers, aov

#VISUAL CHART EX
monthly_revenue = (
    df.groupby(["year", "month"], as_index=False)["revenue"]
    .sum()
    .sort_values(["year", "month"])
)

plt.figure(figsize=(10,5))
plt.plot(monthly_revenue["month"], monthly_revenue["revenue"])
plt.title("Monthly Revenue Trend")
plt.xlabel("Month")
plt.ylabel("Revenue")
plt.show()




