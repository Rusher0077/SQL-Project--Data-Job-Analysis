/* Question: What are the top 5 high demand skills for roles like Data Analyst */
SELECT
    skills,
    count (skills_job_dim.job_id) as demand_count
FROM job_postings_fact

inner join skills_job_dim on skills_job_dim.job_id = job_postings_fact.job_id
inner join skills_dim on skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY 
    skills

ORDER BY demand_count DESC
LIMIT 5
