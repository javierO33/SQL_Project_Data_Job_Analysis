/*
The following CTE (Common Table Expression) retrieves the top 10 highest paying jobs in Argentina,
including the job title, company, location, schedule type, and average annual salary.
*/
WITH top_jobs AS(
    SELECT 
    job_postings_fact.job_id,
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
)
--The query displays the required skills for the highest paying jobs in Argentina.
SELECT
    top_jobs.*,
    skills_dim.skills
FROM top_jobs
INNER JOIN skills_job_dim ON top_jobs.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    top_jobs.salary_year_avg DESC
/*
This is an auxiliary query to create an CSV file to generate a graph of the most
demand skills in the top jobs.
*/
SELECT
    COUNT(skills_dim.skill_id) as skills_demand_count,
    skills_dim.skills
FROM top_jobs
INNER JOIN skills_job_dim ON top_jobs.job_id = skills_job_dim.job_id 
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY
    skills_dim.skills
ORDER BY
    skills_demand_count DESC
LIMIT 10




