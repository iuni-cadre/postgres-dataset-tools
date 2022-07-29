-- These are the questions Jaci asked on 2022.03.03
--
-- 1. How many people are using CADRE gateway per month?
--
--    This is the number of queries per month
with
  queries as ( select qr.job_id, u.user_id, u.email, to_char(qr.created_on, 'YYYY') as yr, to_char(qr.created_on,'MM') as mon, to_char(qr.created_on,'DD') as dy , qr.data_type from query_result qr join user_job uj using(job_id) join users u using(user_id)),
  queries_per_month as ( select job_id, user_id,email,yr,mon,dy,data_type from queries)
select yr||'-'||mon as yrmon,count(*) as cnt from queries_per_month group by rollup(yr,mon) order by yr,mon;

-- users per month
with
  queries as ( select qr.job_id, u.user_id, u.email, to_char(qr.created_on, 'YYYY') as yr, to_char(qr.created_on,'MM') as mon, to_char(qr.created_on,'DD') as dy , qr.data_type from query_result qr join user_job uj using(job_id) join users u using(user_id)),
  queries_per_month as ( select job_id, user_id,email,yr,mon,dy,data_type from queries),
  user_queries_per_month as (select user_id, yr||'-'||mon yrmon, count(*) numqueries from queries_per_month group by yr,mon, user_id)
select yrmon, sum(numqueries) numqueries, count(*) as numusers from user_queries_per_month group by rollup(yrmon) order by yrmon nulls last;

-- 2. What percentage of monthly CADRE gateway users are using each dataset?
--
--    This is the number of queries per month for each of the datasets.
with query_result as (select date(created_on) created_on, data_type from query_result)
  select to_char(created_on, 'YYYY-MM') yrmon, data_type, count(*) as cnt from query_result group by yrmon, data_type order by yrmon
  \crosstabview yrmon data_type cnt

with query_result as (select job_id,date(created_on) created_on, data_type from query_result),
     query_result_per_user as (select u.user_id, to_char(qr.created_on, 'YYYY-MM') yrmon, data_type, count(*) as numqueries from query_result qr join user_job using(job_id) join users u using(user_id) group by yrmon, data_type, u.user_id order by yrmon)
select yrmon, data_type, count(*) as num_users, sum(numqueries) numqueries from query_result_per_user group by rollup(yrmon, data_type) order by yrmon,data_type nulls last
;

-- 3. Should we continue to host all three datasets in CADRE? If not, what to remove?
--
-- 4. How many people are using the graph database capabilities of CADRE?
--
-- 5. What percentage of gateway users per month are selecting the radio buttons to build a citation or reference network?
--
--    I don't think this was tracked from the beginning. It appears that queries used on the form get recorded to the metadb
--    on 2021.05.03. Some queries to get an idea of when this could've been implemented.
--      Query a: select job_id,started_on,query::jsonb->'job_id' from user_job where query <> '' order by started_on limit 1;
--      Query b: with q as (select coalesce(query,'')='' "empty?", to_char(started_on,'YYYY') as "year" from user_job) select ('Empty query? '|| "empty?"::text) "empty?", year, count(*) cnt from q group by "empty?",year order by year \crosstabview year "empty?" cnt
--      Query c: with q as (select coalesce(query,'')='' "empty?", to_char(started_on,'YYYY-MM') as yrmon from user_job) select ('Empty query? '|| "empty?"::text) "empty?", yrmon, count(*) cnt from q group by "empty?",yrmon order by yrmon \crosstabview yrmon "empty?" cnt
--      Query d: with q as (select coalesce(query,'')='' "empty?", started_on from user_job) select "empty?"::text, count(*) as count, min(started_on)::date  first_date, max(started_on)::date last_date from q group by "empty?";
with q(started_on,qedges) as (select to_char(started_on,'YYYY-MM'),query::jsonb -> 'graph' -> 'edges' from user_job where type='QUERY' and query <> ''),
     graph_queries(started_on, "w/o_graph", "w_graph",total_queries) as ( select started_on, count(*) filter (where qedges = '[]') as without_graph_query, count(*) filter (where qedges <> '[]') as with_graph_query, count(*) from q group by started_on order by started_on)
select started_on yrmon,
  format('%s (%s)', to_char("w/o_graph", '999G999'),to_char(100.0 * "w/o_graph" / total_queries,'00.99')) "w/o_graph (%)",
  format('%s (%s)', to_char("w_graph", '999G999'),to_char(100.0 * "w_graph" / total_queries,'00.99')) "w_graph (%)",
  total_queries "tot_queries"
from graph_queries;


-- This how the graph queries are distributed. Initial exploration to answer questions 4 and 5!
with graphqueries as (select job_id,user_id,job_status,type,dataset,started_on,query::jsonb from user_job where type='QUERY' and query::jsonb -> 'graph' -> 'edges' <> '[]'),
     graphqueries_simplified as (select job_id,user_id,job_status,dataset,to_char(started_on,'YYYY-MM') yrmon,query #>> '{graph,edges,0,relation}' as relation, query #>> '{graph,edges,0,source}' as source, query #>> '{graph,edges,0,target}' as target from graphqueries)
select yrmon, dataset || ' - ' || relation citation_tbl, count(*) cnt from graphqueries_simplified
  group by yrmon, relation, dataset;


-- James McCombs stated that I ought to look at only queries that report 'Citations', and 'Referencesr' since that's the only
-- thing supported by janusgraph! This is to answer questions 4 and 5!
--
-- To answer the radio buttons for "citation" or "reference" network
with graphqueries as (select job_id,user_id,job_status,type,dataset,started_on,query::jsonb from user_job where type='QUERY' and query::jsonb -> 'graph' -> 'edges' <> '[]'),
     graphqueries_simplified as (select job_id,user_id,job_status,dataset,to_char(started_on,'YYYY-MM') yrmon,query #>> '{graph,edges,0,relation}' as relation, query #>> '{graph,edges,0,source}' as source, query #>> '{graph,edges,0,target}' as target from graphqueries)
select yrmon, dataset || ' - ' || relation citation_tbl, count(*) cnt from graphqueries_simplified
  where -- upper(source) = 'Paper' and upper(source) = upper(target) and
  upper(relation) in ('CITATIONS','REFERENCES')
  group by yrmon, relation, dataset
\crosstabview yrmon citation_tbl cnt



-- ------------------------------------------------------------------------------
--
-- Additional info for Ben.
--
-- 1. Tool usage by month
with jobs(job_id,user_id,type,started_on) as (select job_id,user_id,type,date(started_on) from user_job)
  select to_char(started_on,'YYYY-MM') yrmon, type, count(*) count from jobs group by yrmon,type order by yrmon
\crosstabview yrmon type count

-- 2. Domain distribution
with user_email(user_id, email, domain) as ( select user_id, email, (regexp_split_to_array(email, '@'))[2] from users)
  -- select * from user_email
  select domain, count(*) as cnt from user_email group by domain order by cnt desc, domain
;
