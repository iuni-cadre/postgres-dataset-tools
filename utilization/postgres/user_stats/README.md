# Folder Contains scripts and commands for IUNI1 and Postgres users

## Steps

### First, as postgres at /pgsql/11/data/base, run the following Unix commands to obtain the data

- du -hs * >> /pgsql/db_sizes.csv
- last >> /pgsql/last.csv
- psql
- \copy (select oid, datname from pg_database order by datname) to '/pgsql/db_names.csv' csv header;

### Now move the files generated to directory that has get_stats.py file and a python environment with pandas

### Run get_stats.py