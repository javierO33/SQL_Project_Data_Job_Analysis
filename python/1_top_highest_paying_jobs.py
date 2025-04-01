import pandas as pd
import matplotlib.pyplot as plt


df = pd.read_csv(r"csv_files\top_paying_jobs.csv")
df = df.sort_values(by="salary_year_avg", ascending=False)

df_top = df.head(10)

plt.figure(figsize=(12, 6))
plt.barh(df_top["job_title"], df_top["salary_year_avg"], color="royalblue")
plt.xlabel("Average Annual Salary (USD)")
plt.ylabel("Job Title")
plt.title("Top 10 Highest Paying Jobs in Argentina")
plt.gca().invert_yaxis()  
plt.show()
