# HR-screening resume templates for typical target roles

Дата подготовки: 2026-05-24  
Автор: Север  
Назначение: 5 гипотетических профилей под типовые вакансии из job-search среза.

Важно: это **не личное резюме Алёны** и не готовые документы для отправки.  
Это “сферические кандидаты”, которые показывают, какие слова, структура и опыт проходят первичный HR/ATS-screening для разных классов вакансий.

## Общий принцип

Для реального резюме нельзя выдумывать опыт.  
Но для проектирования профиля можно посмотреть, какой “идеальный кандидат” проходит фильтры:

- job title совпадает с вакансией;
- первые 6–8 bullets повторяют язык рынка;
- стек вынесен наверх;
- достижения сформулированы через data quality, pipeline reliability, DWH, SQL performance, data marts;
- рисковые gaps закрыты transferable формулировками, а не ложью.

---

# Resume 1 — Data Warehouse / SQL Performance Engineer

## Target vacancy slice

Подходит для вакансий типа:

- Senior Data Engineer, если роль SQL/DWH-heavy;
- Data Warehouse Engineer;
- DWH Analyst;
- Database/Data Engineer with SQL performance focus;
- roles with Teradata / enterprise DWH / data marts / ETL troubleshooting.

Вдохновлено вакансиями:

- Pixaera — Senior Data Engineer
- Remote People — Senior Data Engineer
- Socure — Analytics Engineer
- DOOR3 / GT-like Senior Data Engineer roles

## Hypothetical candidate profile

**Name:** Candidate A  
**Title:** Senior Data Warehouse Engineer / Advanced SQL Specialist  
**Location:** EU / Remote  
**Work format:** B2B / contractor / remote employment  

**Summary:**  
Senior Data Warehouse Engineer with 6+ years of experience building, validating and troubleshooting enterprise DWH layers. Strong in advanced SQL, query performance tuning, EXPLAIN-plan analysis, ETL/ELT re-processing, data reconciliation and incident investigation. Experienced in turning unstable source data and business rules into reliable data marts for reporting and downstream analytics.

## Core skills

- Advanced SQL: window functions, CTEs, complex joins, aggregation logic
- Enterprise DWH: Teradata, Greenplum, PostgreSQL-like systems
- Data marts: fact/dimension modelling, reconciliation, acceptance checks
- ETL/ELT: pipeline investigation, re-processing, batch validation
- Performance: EXPLAIN plans, query tuning, spool/performance troubleshooting
- Data quality: duplicate checks, null checks, count reconciliation, source-target validation
- Documentation: S2T mapping, data lineage, test scenarios
- Tools: DBeaver, SQL clients, Git, Jira/Confluence, BI tools

## Experience bullets

**Senior Data Warehouse / Data Analyst — Enterprise Retail DWH**

- Built and validated SQL prototypes for data marts used by business reporting and analytical teams.
- Investigated production incidents in enterprise DWH pipelines, including data mismatches, failed loads and query performance issues.
- Used EXPLAIN plans and SQL refactoring to reduce heavy query pressure and isolate bottlenecks in complex view chains.
- Designed source-to-target checks for ETL acceptance: row counts, duplicate detection, null checks and aggregate reconciliation.
- Supported re-processing of historical data windows and validated reload results against raw/source layers.
- Worked with business analysts, architects and developers to translate business logic into stable DWH structures.
- Documented mapping rules, data lineage and validation scenarios for release and regression testing.

## ATS keywords

Data Warehouse, DWH, Advanced SQL, Teradata, EXPLAIN plans, query tuning, performance troubleshooting, data marts, ETL re-processing, data reconciliation, data quality, S2T mapping, incident investigation.

## HR-screening angle

This profile passes roles where the hiring manager needs someone who can **own SQL-heavy DWH reliability**, not a pure Python/Spark engineer.

---

# Resume 2 — Analytics Engineer / dbt / Cloud Warehouse

## Target vacancy slice

Подходит для вакансий типа:

- Senior Analytics Engineer;
- BI Analytics Engineer;
- Analytics Engineer with dbt/Snowflake/BigQuery/Redshift;
- data modelling + business metrics + curated layers.

Вдохновлено вакансиями:

- Entravision — BI Analytics Engineer
- Playbook-like Senior Analytics Engineer roles
- Job&Talent-like Senior Analytics Engineer roles
- Socure — Analytics Engineer

## Hypothetical candidate profile

**Name:** Candidate B  
**Title:** Analytics Engineer / Data Modelling Specialist  
**Location:** EU / Remote  
**Work format:** remote employment / B2B  

**Summary:**  
Analytics Engineer with strong SQL and DWH background, focused on building reliable analytical layers between raw data and business reporting. Experienced in data modelling, curated data marts, quality checks, documentation and translating business requirements into scalable datasets. Able to work across BI, data engineering and product analytics teams.

## Core skills

- SQL modelling for analytics and reporting
- dbt-style transformations: models, tests, documentation, lineage
- Cloud DWH concepts: Snowflake, BigQuery, Redshift; transferable from enterprise DWH
- Data marts: facts, dimensions, semantic layers
- BI enablement: governed datasets, metrics definitions, dashboards support
- Data quality: tests, reconciliation, anomaly detection
- Stakeholder translation: business logic → data model
- Git-based collaboration and release documentation

## Experience bullets

**Analytics Engineer — Enterprise Data Platform**

- Designed curated data marts for reporting, KPI tracking and ad-hoc analytics.
- Translated business rules into SQL transformations and documented logic for analysts and developers.
- Implemented data quality checks to validate completeness, uniqueness and consistency of analytical datasets.
- Supported BI teams by creating reliable, reusable datasets instead of one-off SQL extracts.
- Investigated metric discrepancies between source systems, DWH layers and dashboard outputs.
- Refactored complex SQL transformations to improve readability, maintainability and execution performance.
- Collaborated with data engineers to align upstream pipelines with downstream analytical needs.

## ATS keywords

Analytics Engineer, dbt, SQL, data modelling, data marts, semantic layer, Snowflake, BigQuery, Redshift, BI infrastructure, metrics definitions, data quality tests, documentation, lineage.

## HR-screening angle

This profile passes roles where the employer wants a bridge between **Data Engineering and BI/Product Analytics**.

---

# Resume 3 — Data Quality / ETL Reconciliation Engineer

## Target vacancy slice

Подходит для вакансий типа:

- Data Quality Engineer;
- ETL QA Analyst;
- Data Reconciliation Analyst;
- Data Warehouse QA / DQ Engineer;
- migration/reconciliation-heavy roles.

Вдохновлено вакансиями и требованиями:

- Socure — pipeline reliability and governance
- Remote People / Pixaera — production pipelines
- roles using data quality, governance, reconciliation, ETL checks

## Hypothetical candidate profile

**Name:** Candidate C  
**Title:** Data Quality Engineer / ETL Reconciliation Specialist  
**Location:** EU / Remote  
**Work format:** B2B / contract / remote employment  

**Summary:**  
Data Quality Engineer with strong SQL background and enterprise DWH experience. Specialized in validating ETL/ELT pipelines, reconciling source and target layers, detecting duplicates/nulls/aggregate mismatches, and supporting incident resolution. Comfortable working with raw, staging and data mart layers in regulated or high-volume environments.

## Core skills

- SQL-based DQ checks: not-null, uniqueness, duplicates, aggregates
- Source-target reconciliation
- ETL acceptance and regression testing
- Historical reload / re-processing validation
- Incident analysis and root-cause investigation
- Data lineage and mapping verification
- Test documentation and release support
- Enterprise DWH: Teradata / SQL platforms

## Experience bullets

**Data Quality / DWH Analyst — Enterprise Retail Data Platform**

- Designed SQL checks to compare source, staging and target DWH layers before release.
- Investigated discrepancies in counts, sums, dates and business keys across ETL loads.
- Built duplicate detection and null-check scripts for production data acceptance.
- Validated historical re-processing windows and documented deviations for developers and analysts.
- Analysed failed DQ checks in orchestration logs and connected them to specific data intervals and source patterns.
- Coordinated with data engineers to resolve root causes without masking business logic errors.
- Prepared concise DQ reports for release decisions and business stakeholders.

## ATS keywords

Data Quality, ETL testing, data reconciliation, source-target validation, DQ checks, SQL, data warehouse, incident investigation, duplicate detection, null checks, regression testing, data lineage.

## HR-screening angle

This profile passes roles where the company cares more about **data correctness and production reliability** than trendy cloud stack.

---

# Resume 4 — BI / Data Product Analyst with SQL-heavy background

## Target vacancy slice

Подходит для вакансий типа:

- Data Product Analyst;
- BI Developer / BI Analyst with SQL;
- Analytics Engineer with dashboard support;
- Product/Data Analyst where SQL/dbt/data modelling are core.

Вдохновлено вакансиями:

- Ci&T — Senior Data Analyst / Data Product Analyst
- Entravision — BI Analytics Engineer
- Job&Talent-like Analytics Engineer roles

## Hypothetical candidate profile

**Name:** Candidate D  
**Title:** SQL-heavy BI / Data Product Analyst  
**Location:** EU / Remote  
**Work format:** remote employment / contractor  

**Summary:**  
BI/Data Product Analyst with strong SQL, DWH and data modelling experience. Builds reliable datasets for reporting, validates business metrics and supports BI users with clean, documented data. Strong at investigating discrepancies between operational sources, DWH layers and dashboards.

## Core skills

- Advanced SQL for reporting and analytics
- Data modelling for BI: facts, dimensions, metric logic
- BI tools: Tableau / Power BI / Metabase-type tools
- Data quality for dashboards and reporting layers
- Product/business metric definitions
- Ad-hoc analysis and stakeholder support
- DWH incident investigation
- Documentation of metric logic and data lineage

## Experience bullets

**BI / Data Product Analyst — Retail Analytics Platform**

- Created SQL datasets and reusable views for operational and management reporting.
- Validated KPI logic across raw data, DWH marts and BI dashboards.
- Investigated differences between business reports and warehouse data, isolating source and transformation issues.
- Supported ad-hoc requests while converting recurring analysis into stable data marts.
- Documented metric definitions, filters and joins to reduce ambiguity for business users.
- Worked with developers to improve reporting performance and reduce manual extracts.
- Participated in release testing for BI-facing data changes.

## ATS keywords

BI Analyst, Data Product Analyst, SQL, data modelling, KPI definitions, data marts, dashboard data quality, Power BI, Tableau, Metabase, ad-hoc reporting, DWH, analytics.

## HR-screening angle

This profile passes roles where the company needs someone practical between **BI, SQL and DWH**, not a pure dashboard designer.

---

# Resume 5 — AI Data Trainer / SQL Evaluator side-stream

## Target vacancy slice

Подходит для быстрых freelance/side-stream ролей:

- AI Trainer — Data Science / SQL;
- SQL evaluator;
- AI coding/data tasks reviewer;
- LLM data quality evaluator;
- domain expert for analytics tasks.

Вдохновлено side-stream рынком:

- Mindrift-type AI Trainer roles
- Mercor Analytics Engineer / AI Training roles
- SME evaluator roles

## Hypothetical candidate profile

**Name:** Candidate E  
**Title:** SQL / Data Warehousing Expert for AI Evaluation  
**Location:** Remote  
**Work format:** freelance / project-based / B2B  

**Summary:**  
Data warehousing and SQL expert available for AI evaluation, data-task review and technical content validation. Experienced in enterprise DWH, advanced SQL, ETL validation, data quality checks and performance troubleshooting. Able to evaluate AI-generated SQL, identify logical errors and write clear feedback for model improvement.

## Core skills

- Advanced SQL review and correction
- DWH concepts: fact/dimension logic, data marts, ETL/ELT
- Query logic validation: joins, grouping, windows, filters, dates
- Data quality scenarios: duplicates, nulls, reconciliation
- Technical explanation in plain English/Russian
- AI-generated answer evaluation
- Prompt/task writing for SQL and DWH cases
- Error analysis and feedback writing

## Experience bullets

**SQL / DWH Subject Matter Expert — AI Data Evaluation Projects**

- Reviewed AI-generated SQL solutions for correctness, performance and business logic alignment.
- Identified common model errors in joins, aggregation levels, date filters and window functions.
- Created SQL/DWH test cases for data quality, reconciliation and ETL validation tasks.
- Wrote concise feedback explaining why a generated answer was incorrect and how to fix it.
- Validated technical explanations for clarity, factual accuracy and practical usefulness.
- Used enterprise DWH experience to design realistic scenarios involving raw, staging and mart layers.

## ATS keywords

AI Trainer, SQL Evaluator, Data Science AI Trainer, LLM evaluation, SQL review, data warehousing, DWH, ETL validation, data quality, prompt evaluation, technical feedback, AI data annotation.

## HR-screening angle

This profile passes side-stream roles where the company wants a **domain expert who can judge AI output**, not necessarily a cloud data engineer.

---

# How to turn templates into real resumes later

For each real application:

1. Pick one profile closest to vacancy.
2. Keep only true experience.
3. Replace cloud-stack claims with honest transferable wording:
   - not “Snowflake expert” if no Snowflake;
   - use “enterprise DWH experience, transferable to Snowflake/BigQuery/Redshift”.
4. Add 6–8 keywords from the exact vacancy.
5. Keep gaps visible but not fatal:
   - “dbt — familiar / currently upskilling”;
   - “cloud DWH — transferable DWH background”.
6. Do not overfit to one vacancy if applying broadly.
