-- Print size of tables
SELECT pg_database.datname as "databasename",
pg_database_size(pg_database.datname)/1024/1024 AS sizeMB
FROM pg_database ORDER by pg_database_size(pg_database.datname) DESC;

-- Print relation name, namespace, and size of relation for all relations
SELECT relkind,
   relname,
   pg_catalog.pg_namespace.nspname,
   pg_relation_size(pg_catalog.pg_class.oid)/1024/1024 AS sizeMB
FROM   pg_catalog.pg_class
       INNER JOIN pg_catalog.pg_namespace
         ON relnamespace = pg_catalog.pg_namespace.oid
ORDER  BY pg_catalog.pg_namespace.nspname,
          pg_relation_size(pg_catalog.pg_class.oid) DESC;

-- Same as above but group by schema and sum table sizes
SELECT pg_catalog.pg_namespace.nspname,
   sum(pg_relation_size(pg_catalog.pg_class.oid)/1024/1024) AS sizeMB
FROM   pg_catalog.pg_class
       INNER JOIN pg_catalog.pg_namespace
         ON relnamespace = pg_catalog.pg_namespace.oid
GROUP BY pg_catalog.pg_namespace.nspname
ORDER  BY pg_catalog.pg_namespace.nspname DESC;

-- Print schemas in current db
select schema_name
from information_schema.schemata;
