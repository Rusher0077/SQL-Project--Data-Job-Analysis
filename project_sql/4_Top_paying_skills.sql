/* Question: What are the top skills based on salary? */

SELECT
    skills,
    round(avg(job_postings_fact.salary_year_avg), 0 ) as avg_salary


FROM job_postings_fact

inner join skills_job_dim on skills_job_dim.job_id = job_postings_fact.job_id
inner join skills_dim on skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst' and salary_year_avg is not NULL
GROUP BY 
    skills 
ORDER BY
    avg_salary DESC
LIMIT 10 

