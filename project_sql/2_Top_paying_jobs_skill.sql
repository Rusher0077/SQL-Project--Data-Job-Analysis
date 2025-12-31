/* Questions: What skills are required for the top-paying Data Analyst roles? */
WITH top_paying_skills AS (
    SELECT job_id,
        job_title,
        job_schedule_type,
        salary_year_avg,
        name AS company_name
    FROM job_postings_fact
        left JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT top_paying_skills.*,
    skills
FROM top_paying_skills
    INNER JOIN skills_job_dim ON top_paying_skills.job_id = skills_job_dim.job_id
    INNER join skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY salary_year_avg DESC