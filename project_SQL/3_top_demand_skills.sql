-- Query the most in-demand skills in Argentina.
SELECT 
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) as demand
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_country ='Argentina'
GROUP BY
    skills
ORDER BY
    demand DESC
LIMIT 10
-- Query the most in-demand skills worldwide.
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