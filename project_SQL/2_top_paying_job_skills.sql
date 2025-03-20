
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
        job_work_from_home IS TRUE
        AND salary_year_avg IS NOT NULL
        AND job_title_short = 'Data Analyst'
     ORDER BY
        job_postings_fact.salary_year_avg DESC

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

   



