-- This query retrieves the most demanded and highest paying skills
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
      demand DESC,
    avg_salary DESC
  
LIMIT 25
    
