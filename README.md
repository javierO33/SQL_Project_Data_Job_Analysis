# Introduction
Using a dataset with job market data focused on the IT sector, this project explores the highest-paying jobs, the most in-demand skills in the Argentine market, and compares them with global trends to assess whether the local market is up to date. Additionally, It analyzes the highest-paying skills in Argentina and which are the optimal skills in terms of demand and average salary.

You can check the SQL queries right here: [project_SQL folder](/project_SQL/)

# Background  
The idea for this project comes from the need to understand the most in-demand skills and technologies in the Argentine job market. The goal is to identify key areas to learn in order to improve job opportunities. As a future engineer, it is important to stay up to date with the latest technologies to remain competitive and decide which area to specialize in.  

## To make an informed decision on which technologies and areas to study, I aim to answer the following questions:  
1. What are the top-paying jobs in Argentina?  
2. What skills are required for those top-paying jobs?  
3. What skills are most in demand in Argentina, and how do they compare globally?  
4. Which skills are associated with higher salaries?  
5. What are the most optimal skills to learn based on demand and salary?  

# Tools Used in This Project  

For the analysis of this data, I used several tools:  
- **SQL**: The most important tool, allowing me to query databases and answer key questions.  
- **Python**: Used to create visualizations and better understand the data.  
- **Visual Studio Code**: Used for database management and executing SQL queries and Python code.  
- **Git & GitHub**: Essential for version control and sharing the project.

# Analysis

Each query of this project answer a question to make my decision, there is how I approched each quest

### 1. What are the top-paying jobs in Argentina?
This query retrieves the top 10 highest-paying job postings in Argentina. It selects key job details such as job ID, title, company name, location, schedule type, average annual salary, and posting date. The data is sourced from the ```job_postings_fact``` table, with company names retrieved via a **LEFT JOIN** with the ```company_dim``` table. The results are filtered to include only jobs with a non-null salary and are sorted in descending order based on salary.

```sql
SELECT 
  job_postings_fact.job_id,
  job_postings_fact.job_title,
  company_dim.name AS company,
  job_postings_fact.job_location,
  job_postings_fact.job_schedule_type,
  job_postings_fact.salary_year_avg,
  job_postings_fact.job_posted_date
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    salary_year_avg IS NOT NULL
    AND job_location LIKE('%Argentina%')
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
The conclusions we can draw from this query are:

- **Wide Salary Range**: The highest paying jobs range from $147,500 to $98,283.
- **Diverse Employers**: The results show 9 different companies offering high-paying jobs, indicating strong competition.
- **Job Title Dominance**: All of the high-paying roles are in the data field, showing its dominance over other IT areas.

![Top Paying Jobs](assets\top_paying_jobs.png)
*Bar Graph Visualizing the top 10 salaries in Argentina*

### 2. What skills are required for those top-paying jobs?

The CTE (Common Table Expression) ```top_jobs``` retrieves the top 10 highest paying jobs in Argentina. The main query then retrieves the skills associated with those 10 jobs. Using an **INNER JOIN** between the tables ```skills_job_dim```, ```top_jobs```, and ```skills_dim```, I obtained the skills associated with each job, and then I filtered the results to only include those in Argentina.

```sql
WITH top_jobs AS(
    SELECT 
        job_postings_fact.job_id,
        job_postings_fact.job_title,
        company_dim.name AS company,
        job_postings_fact.job_location,
        job_postings_fact.job_schedule_type,
        job_postings_fact.salary_year_avg,
        job_postings_fact.job_posted_date
    FROM job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        salary_year_avg IS NOT NULL
        AND job_location LIKE('%Argentina%')
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT 
    top_jobs.*,
    skills_dim.skills
FROM top_jobs
INNER JOIN skills_job_dim ON top_jobs.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    top_jobs.salary_year_avg DESC
```
The conclusions we can draw from this query are:
- The skills observed in the results include SQL, Excel, Tableau, Python, R, Linux, and others. The majority of these are tools or skills used by Data Analysts, Data Scientists, Machine Learning professionals, and all jobs related to the Data field. This makes sense, as we found that the top-paying jobs are all in the Data Area.

### 3. What skills are most in demand in Argentina, and how do they compare globally?

With this query, we will obtain the top 10 most in-demand skills for jobs in Argentina. Using an **INNER JOIN** between the tables ```skills_job_dim```, ```skills_job_dim```, and ```skills_dim```, we retrieve the skills associated with each job, then sort them by demand.

```sql
SELECT 
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) as demand
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_location LIKE('%Argentina%')
GROUP BY
    skills
ORDER BY
    demand DESC
LIMIT 10
```
This query does the same as the one above but without the Argentina condition because I want to know if the most in-demand skills in the Argentine market are the same as those in the rest of the world.
```sql
SELECT 
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) as demand
FROM job_postings_fact

INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills
ORDER BY
    demand DESC
LIMIT 10
```
After analising both list we can come to the conclusion that

- **Market Updates**: The most in-demand skills in Argentina are the same as those in the global market. This is a good sign that the Argentine job market is adopting top technologies.
- **Tools for Analysis and Visualization**: The most in-demand tools include Excel, Power BI, and Tableau.
- **Data Analyst Languages**: The top two most in-demand skills are SQL and Python, both essential for data-related tasks. R is also commonly used.
- **Big Data and Cloud**: Tools like Apache Spark and Azure are in high demand.
- **Development**: We can conclude that most in-demand tools are focused on data analysis, except for Java.

![Top Demand Skills Argentina](assets\top_demand_skills_argentina.png)
*Bar Graph Visualizing the 10 most in-demand skills in Argentina*

![Top Demand Skills Worldwide](assets\top_demand_skills_worldwide.png)
*Bar Graph Visualizing the 10 most in-demand skills Worldwide*

### 4. Which skills are associated with higher salaries?

This query identifies the skills associated with the highest salaries. Using an **INNER JOIN** between the tables ```job_postings_fact```, ```skills_job_dim```, and ```skills_dim```, it retrieves the skills linked to each job, then groups them by skill and sorts them by average salary.

```sql
SELECT 
    skills_dim.skills,
    ROUND (AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.job_location LIKE('%Argentina%')
    AND job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
ORDER BY
    avg_salary DESC
LIMIT 10
```
| Skill     | Average Salary ($) |
|-----------|----------------------|
| GitLab    | 147,500              |
| Golang    | 147,500              |
| GDPR      | 147,500              |
| Scala     | 143,080              |
| Alteryx   | 134,241              |
| Jenkins   | 126,675              |
| Kubernetes| 123,201              |
| Linux     | 122,892              |
| Flow      | 122,722              |
| Shell     | 120,000              |
Here is a summary of the highest-paying skills in the Argentine job market:

- **Software Development & DevOps**: GitLab, Jenkins, Golang, Scala
- **Infrastructure & Cloud Computing**: Kubernetes, Linux, Shell
- **Data Analysis & Automation**: Alteryx, Flow
- **Security & Regulation**: GDPR



### 5. What are the most optimal skills to learn based on demand and salary?

This query shows the most in-demand and highest-paying skills. Using an **INNER JOIN** between the tables ```job_postings_fact```, ```skills_job_dim```, and ```skills_dim```, it retrieves the skills with at least 10 job offers, then sorts them by average salary and demand.

```sql
SELECT
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) as demand,
    ROUND (AVG(job_postings_fact.salary_year_avg)) as avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skills
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand DESC
LIMIT 25
```
 Skill          | Demand | Average Salary (ARS) |
|---------------|--------|----------------------|
| Mongo         | 262    | 170,715              |
| dplyr         | 19     | 160,667              |
| Node          | 65     | 154,408              |
| Cassandra     | 530    | 154,124              |
| Watson        | 31     | 152,844              |
| RShiny        | 29     | 151,611              |
| Hugging Face  | 37     | 148,648              |
| Neo4j         | 123    | 147,708              |
| Scala         | 1,912  | 145,120              |
| Kafka         | 1,642  | 144,754              |
| PyTorch       | 1,081  | 144,470              |
| MXNet         | 50     | 143,695              |
| Theano        | 37     | 143,404              |
| Shell         | 731    | 143,370              |
| Golang        | 109    | 143,139              |
| Airflow       | 1,506  | 142,386              |
| TensorFlow    | 1,225  | 142,370              |
| Spark         | 4,025  | 141,734              |
| Redshift      | 1,520  | 140,792              |
| Airtable      | 22     | 140,615              |
| Ruby on Rails | 18     | 140,130              |
| Scikit-learn  | 688    | 139,603              |
| DynamoDB      | 220    | 139,548              |
| Rust          | 71     | 139,349              |
| Clojure       | 12     | 139,342              |

Here is a summary of the most optimal skills in the job market:

- **Software Development & Backend**: Node, Mongo, Cassandra, Scala, Golang, Ruby on Rails, 4 out of these 6 technologies are in the top 10 highest-paying skills, with Cassandra having the most demand and Mongo being the highest-paying.
- **Big Data & Data Analysis**: Spark, Redshift, Airflow, DynamoDB, Hugging Face, Scikit-learn, TensorFlow, PyTorch, MXNet, Theano, RShiny, The data analysis field has the most skills in the top 25 based on demand and salary, with 12 skills listed.
- **Automation & Orchestration**: Shell, Airflow.
- **Artificial Intelligence Technologies**: Watson is the 5th highest-paying skill and the only technology in its field.
- **Frontend Technologies & Visualization**: dplyr, Airtable
- **Networking and Distributed Services**: Kafka, Neo4j, Clojure.

# What I Learned

- **Complex Query Crafting**: Advanced SQL queries using CTEs and subqueries, merging tables with both INNER JOIN and LEFT JOIN.
- **Data Aggregation**: Familiarized myself with the GROUP BY function and the use of aggregate functions like COUNT() and AVG().
- **Data Visualization and Analysis**: Introduction to Python, using libraries to create and display graphs for better understanding of the results.
- **Analytical Thinking**: Developed an analytical approach to real-world problems and learned how to solve complex situations.

# Conclusions

### Insights
1. **Top-Paying Jobs in Argentina**: The highest-paying jobs in Argentina are in the Data field, with the highest salary reaching $147,500.
2. **Skills for High-Paying Jobs in Argentina**: High-paying jobs require advanced knowledge of a wide range of tools related to Data Analysis, Machine Learning, and Data Science.
3. **Most In-Demand Skills**: SQL and Python are the most in-demand skills both in Argentina and worldwide. These are the most valuable skills to learn in the market.
4. **Skills with the Highest Salaries in Argentina**: Specialized skills such as GitLab and Golang in Software Development & DevOps offer the highest salaries in the Argentine job market.
5. **Optimal Skills for Job Market Value**: SQL leads in demand and offers a high average salary, making it one of the most valuable skills to learn.

### Closing Thoughts

This project enhanced my SQL skills and provided my first approach to Python, giving me important knowledge about the Argentine job market. The findings from the analysis helped me understand which skills are the best to learn for my future as an engineer. As a result, I decided to continue learning in the Data field, as the highest-paying jobs are related to it. Additionally, the top in-demand skills, such as SQL, Python, Excel, and Power BI, are also part of the Data field.
This project also helped me realize that the Argentine job market is competitive and evolving alongside the global market.