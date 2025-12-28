
/* Questions: What skills are required for the top-paying Data Analyst roles? */

WITH top_paying_skills as (
    SELECT
        job_id,
        job_title,
        job_schedule_type,
        salary_year_avg,
        name as company_name
    FROM job_postings_fact
        left JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE job_title_short = 'Data Analyst'
        and job_location = 'Anywhere'
        AND salary_year_avg is not NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10  
)

SELECT 
    top_paying_skills.*,
    skills
FROM top_paying_skills

inner JOIN skills_job_dim on top_paying_skills.job_id = skills_job_dim.job_id
inner join skills_dim on skills_dim.skill_id = skills_job_dim.skill_id

ORDER BY 
    salary_year_avg desc

