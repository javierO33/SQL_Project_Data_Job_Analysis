--Buscar los empleos en Argentina

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
    job_work_from_home IS TRUE
    AND salary_year_avg IS NOT NULL
    AND job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC
LIMIT 10