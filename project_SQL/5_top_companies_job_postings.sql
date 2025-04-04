-- This query returns the top 10 companies with the highest number of job postings.
SELECT
    company_dim.name AS company_name,
    COUNT(job_postings_fact.job_id) AS job_count
FROM job_postings_fact
INNER JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_postings_fact.job_country = 'Argentina'
GROUP BY
    company_dim.name
ORDER BY
    job_count DESC
LIMIT 10

    
