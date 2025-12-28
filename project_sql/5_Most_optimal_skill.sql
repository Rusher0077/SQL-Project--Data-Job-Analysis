/* Question: What are the most optimal skills to learn (a.k.a high demand with high paying salary) */
WITH skills_demand as (
    SELECT 
        skills_dim.skills,
        skills_dim.skill_id,
        count(skills_job_dim.job_id) as demand_count
    FROM job_postings_fact
        inner join skills_job_dim on skills_job_dim.job_id = job_postings_fact.job_id
        inner join skills_dim on skills_dim.skill_id = skills_job_dim.skill_id
    WHERE job_title_short = 'Data Analyst' and job_work_from_home = TRUE and 
    salary_year_avg is not NULL
    GROUP BY skills_dim.skill_id
    

), average_salary as (

    SELECT skills_job_dim.skill_id,
        round(avg(job_postings_fact.salary_year_avg), 0) as avg_salary
    FROM job_postings_fact
        inner join skills_job_dim on skills_job_dim.job_id = job_postings_fact.job_id
        inner join skills_dim on skills_dim.skill_id = skills_job_dim.skill_id
    WHERE job_title_short = 'Data Analyst' and job_work_from_home = TRUE
        and salary_year_avg is not NULL
    GROUP BY skills_job_dim.skill_id
   
   
)

select 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
inner join average_salary on skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER by avg_salary desc,
    demand_count desc
limit 25