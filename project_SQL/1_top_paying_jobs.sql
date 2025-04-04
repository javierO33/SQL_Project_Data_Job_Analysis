--This query retrieves the top 10 highest paying jobs in Argentina.
SELECT 
  job_postings_fact.job_title,
  company_dim.name AS company,
  job_postings_fact.job_location,
  job_postings_fact.salary_year_avg
FROM job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    salary_year_avg IS NOT NULL
    AND job_country = 'Argentina'
ORDER BY
    salary_year_avg DESC
LIMIT 10
