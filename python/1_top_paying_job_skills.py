import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Top 10 Most In-Demand Skills for the Best-Paying Jobs in Argentina
df_demand_skills = pd.read_csv(r'csv_files\skills_demand_count_top_jobs.csv')

x_demand_skills = np.arange(len(df_demand_skills))  
df_demand_skills.sort_values(by="skills_demand_count", ascending=True, inplace=True)
fig, ax = plt.subplots(figsize=(10, 6))
ax.barh(x_demand_skills, df_demand_skills['skills_demand_count'], 0.4, label='Skills', color='blue')
ax.set_xlabel('Demand (Number of Jobs)')
ax.set_title('Top 10 Most In-Demand Skills for the Best-Paying Jobs in Argentina')
ax.set_yticks(x_demand_skills)
ax.set_yticklabels(df_demand_skills['skills'])
ax.legend()


plt.tight_layout()
plt.show()