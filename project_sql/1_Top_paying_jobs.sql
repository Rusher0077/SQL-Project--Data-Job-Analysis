/*  
Questions: What are the top-paying Data Analyst jobs?
 -Identigy the top 10 highest paying Data Analyst roles that are available remotely.
 -Focuses on job postings with specified salaries (remove nulls).
 -Highlight the top paying opportunities for Data Analysts.
*/

SELECT
    job_id,
    job_title,
    job_location,
    job_posted_date,
    job_schedule_type,
    salary_year_avg,
    name as company_name
    

FROM job_postings_fact

left JOIN company_dim  ON company_dim.company_id = job_postings_fact.company_id

WHERE job_title_short = 'Data Analyst'
    and job_location = 'Anywhere'
    AND salary_year_avg is not NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
