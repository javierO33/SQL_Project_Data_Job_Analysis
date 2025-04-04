import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Top 10 Most In-Demand Skills in Argentina
df_argentina = pd.read_csv(r'csv_files\top_demand_skills_Argentina.csv')

x_argentina = np.arange(len(df_argentina))
df_argentina.sort_values(by="demand", ascending=True, inplace=True)  

fig, ax = plt.subplots(figsize=(10, 6))
ax.barh(x_argentina, df_argentina['demand'], 0.4, label='Argentina', color='blue')
ax.set_xlabel('Demand (Number of Jobs)')
ax.set_title('Top 10 Most In-Demand Skills in Argentina')
ax.set_yticks(x_argentina)
ax.set_yticklabels(df_argentina['skills'])
ax.legend()

plt.tight_layout()
plt.show()

#   Top 10 Most In-Demand Skills Worldwide
df_worldwide = pd.read_csv(r'csv_files\top_demand_skills_worldwide.csv')

x_worldwide = np.arange(len(df_worldwide))  
df_worldwide.sort_values(by="demand", ascending=True, inplace=True)

fig, ax = plt.subplots(figsize=(10, 6))
ax.barh(x_worldwide, df_worldwide['demand'], 0.4, label='Worldwide', color='green')
ax.set_xlabel('Demand (Number of Jobs)')
ax.set_title('Top 10 Most In-Demand Skills Worldwide')
ax.set_yticks(x_worldwide)
ax.set_yticklabels(df_worldwide['skills'])
ax.legend()

plt.tight_layout()
plt.show()
