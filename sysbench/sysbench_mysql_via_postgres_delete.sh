
#!/bin/bash

# Variables
DB_NAME="sysbench_fdw"
TABLE_NAME="fdw_mysql_customers"
NUM_THREADS=8
TIME=60
TABLE_SIZE=1000

# Create the FDW table in PostgreSQL for MySQL if it does not exist
psql -U postgres -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS mysql_fdw;"

psql -U postgres -d $DB_NAME <<EOF
CREATE SERVER IF NOT EXISTS mysql_server FOREIGN DATA WRAPPER mysql_fdw
  OPTIONS (host 'percona_mysql', port '3306');

CREATE USER MAPPING IF NOT EXISTS FOR postgres
  SERVER mysql_server OPTIONS (username 'mysql_user', password 'mysql_password');

CREATE FOREIGN TABLE IF NOT EXISTS $TABLE_NAME (
  id serial NOT NULL,
  name text,
  email text
) SERVER mysql_server OPTIONS (dbname 'mydb', table_name 'customers');
EOF

# Run the sysbench test for deleting data from MySQL via PostgreSQL FDW
sysbench oltp_delete   --db-driver=pgsql   --pgsql-user=postgres   --pgsql-password=password   --pgsql-db=$DB_NAME   --pgsql-host=localhost   --pgsql-port=5432   --tables=1   --table-size=$TABLE_SIZE   --threads=$NUM_THREADS   --time=$TIME   --range_size=100   --skip_trx=off   --report-interval=10   --index_updates=on   --reconnect=on   --create_table=off   --table_name=$TABLE_NAME   run
