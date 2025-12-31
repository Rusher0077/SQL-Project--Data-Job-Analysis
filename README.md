# Data Analyst Job Market Analysis

## Introduction
This project focuses on the data analyst job market, analyzing top-paying roles, in-demand skills, and the intersection of high demand and high salary in data analytics.

**SQL Queries:** Check out the raw SQL files here: [project_sql folder](/project_sql/)

## Background
I started this project to better navigate the data analyst job market. My goal was to pinpoint the highest-paid and most in-demand skills to help streamline the job search process for myself and others looking for optimal opportunities.

### Key Questions Analyzed:
1. What are the highest-paying data analyst roles?
2. Which skills are required for these top-paying jobs?
3. What are the most in-demand skills for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn (High Demand + High Salary)?

## Tools Used
To analyze the data analyst job market, I used the following tools:
- **SQL:** The core of my analysis, used to query the database and extract insights.
- **PostgreSQL:** The database management system used to handle the job posting data.
- **Visual Studio Code:** My tool for database management and executing SQL queries.
- **Git & GitHub:** Used for version control and sharing my SQL scripts and analysis.

---

## The Analysis
Each query below targets a specific aspect of the data analyst job market.

### 1. Top Paying Data Analyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, specifically focusing on remote jobs. This highlights the best financial opportunities in the field.

```sql
SELECT 
    job_id,
    job_title,
    job_location,
    job_posted_date,
    job_schedule_type,
    salary_year_avg,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL -- Excluded data without salary info for accurate ranking
ORDER BY salary_year_avg DESC
LIMIT 10;
```
### Insights: 

- **Wide Salary Range:** The top 10 remote data analyst roles span from $184,000 to $650,000.

- **Diverse Employers:** Companies like SmartAsset, Meta, and AT&T are offering these top salaries.

- **Job Title Variety:** Titles range from standard "Data Analyst" to "Director of Analytics."

### 2. Skills for Top Paying Jobs
To understand what skills are required for these high-paying roles, I joined the job postings with the skills data.
Note: I renamed the CTE to top_10_remote_jobs for clarity.

```SQL
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
```
### Insights:

- **SQL** is leading with a bold count of 8.
- **Python** follows closely with a bold count of 7.
- **Tableau** is also highly sought after, with a bold count of 6.
Other skills like **R**, **Snowflake**, **Pandas**, and **Excel** show varying degrees of demand.

### 3. In-Demand Skills for Data Analysts
This query identifies the skills most frequently requested in job postings, showing where job seekers should focus their learning.

```SQL
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY 
    skills
ORDER BY 
    demand_count DESC
LIMIT 5;
```
### Insights:

**SQL** and **Excel** remain the foundational skills for data processing.
**Python**, **Tableau**, and **Power BI** are essential for technical analysis and visualization.

| Skills   | Demand Count |
|----------|--------------|
| SQL      | 7291         |
| Excel    | 4611         |
| Python   | 4330         |
| Tableau  | 3745         |
| Power BI | 2609         |

*Table of the demand for the top 5 skills in data analyst job postings*
### 4. Skills Based on Salary
This query explores the average salaries associated with different skills to identify which technical expertise commands the highest pay.

```SQL
SELECT skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 10;
```
### Insights:

- **Big Data** & **ML**: Top earners specialize in tools like PySpark, Couchbase, and DataRobot.
- **Engineering Crossover**: Knowledge of GitLab, Kubernetes, and Airflow (typically engineering tools) commands a premium.
- **Cloud Tools**: Proficiency in Elasticsearch and Databricks is highly valued.

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| pyspark       |            208,172 |
| bitbucket     |            189,155 |
| couchbase     |            160,515 |
| watson        |            160,515 |
| datarobot     |            155,486 |
| gitlab        |            154,500 |
| swift         |            153,750 |
| jupyter       |            152,777 |
| pandas        |            151,821 |
| elasticsearch |            145,000 |

*Table of the average salary for the top 10 paying skills for data analysts*
### 5. Most Optimal Skills to Learn

This query combines demand and salary data to find the "sweet spot" skills—those that are high in demand and offer high salaries.


```SQL
WITH skill_demand_counts AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND job_work_from_home = TRUE
        AND salary_year_avg IS NOT NULL
    GROUP BY 
        skills_dim.skill_id
), 
skill_avg_salaries AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
    FROM 
        job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE 
        job_title_short = 'Data Analyst'
        AND job_work_from_home = TRUE
        AND salary_year_avg IS NOT NULL
    GROUP BY 
        skills_job_dim.skill_id
)

SELECT 
    skill_demand_counts.skill_id,
    skill_demand_counts.skills,
    demand_count,
    avg_salary
FROM 
    skill_demand_counts
INNER JOIN skill_avg_salaries ON skill_demand_counts.skill_id = skill_avg_salaries.skill_id
WHERE 
    demand_count > 10
ORDER BY 
    avg_salary DESC, 
    demand_count DESC
LIMIT 25;
```

| Skill ID | Skills     | Demand Count | Average Salary ($) |
|----------|------------|--------------|-------------------:|
| 8        | go         | 27           |            115,320 |
| 234      | confluence | 11           |            114,210 |
| 97       | hadoop     | 22           |            113,193 |
| 80       | snowflake  | 37           |            112,948 |
| 74       | azure      | 34           |            111,225 |
| 77       | bigquery   | 13           |            109,654 |
| 76       | aws        | 32           |            108,317 |
| 4        | java       | 17           |            106,906 |
| 194      | ssis       | 12           |            106,683 |
| 233      | jira       | 20           |            104,918 |

*Table of the most optimal skills for data analyst sorted by salary (Displayed top 10)*

 ### Insights:

- **Cloud** & **Big Data**: Skills like Snowflake, Azure, AWS, and Hadoop are high-value.
- **Programming**: Java and Go offer high salaries but lower demand compared to Python.
- **Tools**: Jira and Confluence knowledge is surprisingly lucrative.

# What I Learned
---
Throughout this project, I strengthened my SQL skills in the following areas:

1. **Complex Query Construction**: I mastered advanced SQL techniques, including complex joins and CTEs.
2. **Data Aggregation**: I utilized GROUP BY and aggregate functions like COUNT() and AVG() to summarize data effectively.
3. **Analytical Problem Solving**: I translated real-world business questions into actionable SQL queries.

# Conclusion
---

### Insights
From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs**: Remote data analyst roles show a significant salary spread, with top positions reaching compensation levels as high as $650,000, highlighting the earning potential at senior and specialized levels.

2. **Skills for Top-Paying Jobs**: High compensation data analyst roles consistently emphasize strong expertise in SQL, reinforcing its importance as a core skill for accessing top tier salaries.

3. **Most In-Demand Skills**: SQL emerges as the most frequently requested skill across job postings, making it a foundational requirement for aspiring and experienced data analysts alike.

4. **Skills with Higher Salaries**: Niche and specialized technologies such as SVN and Solidity command higher average salaries, reflecting a market premium for rare and specialized skill sets.

5. **Optimal Skills for Job Market Value**: With both high demand and strong salary outcomes, SQL stands out as one of the most valuable skills for data analysts aiming to maximize their competitiveness in the job market.
