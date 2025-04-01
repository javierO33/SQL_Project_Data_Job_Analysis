import pandas as pd
import matplotlib.pyplot as plt

# Cargar el archivo CSV
df = pd.read_csv(r"csv_files\top_paying_jobs.csv")

# Ordenar por salario de mayor a menor
df = df.sort_values(by="salary_year_avg", ascending=False)

# Seleccionar los 10 trabajos mejor pagados
df_top = df.head(10)

# Crear gráfico de barras
plt.figure(figsize=(12, 6))
plt.barh(df_top["job_title"], df_top["salary_year_avg"], color="royalblue")
plt.xlabel("Average Annual Salary (USD)")
plt.ylabel("Job Title")
plt.title("Top 10 Highest Paying Jobs in Argentina")
plt.gca().invert_yaxis()  # Invertir eje Y para que el mejor pago esté arriba
plt.show()
