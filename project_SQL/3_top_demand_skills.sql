--Añadir para argentina

SELECT 
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) as demand
FROM skills_job_dim
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
INNER JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE
    job_postings_fact.job_title_short = 'Data Analyst' 
GROUP BY
    skills
ORDER BY
    demand DESC
LIMIT 10
