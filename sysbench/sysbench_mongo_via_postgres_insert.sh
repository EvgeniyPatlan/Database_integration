#!/bin/bash

# Variables
DB_NAME="sysbench_fdw"
TABLE_NAME="fdw_mongo_orders"
NUM_THREADS=8
TIME=60
TABLE_SIZE=1000

# Create the FDW table in PostgreSQL for MongoDB if it does not exist
psql -U postgres -d $DB_NAME -c "CREATE EXTENSION IF NOT EXISTS mongo_fdw;"

psql -U postgres -d $DB_NAME <<EOF
CREATE SERVER IF NOT EXISTS mongo_server FOREIGN DATA WRAPPER mongo_fdw
  OPTIONS (address 'percona_mongodb', port '27017');

CREATE USER MAPPING IF NOT EXISTS FOR postgres
  SERVER mongo_server OPTIONS (username 'mongo_user', password 'mongo_password');

CREATE FOREIGN TABLE IF NOT EXISTS $TABLE_NAME (
  order_id serial NOT NULL,
  customer_name text,
  order_date date,
  amount numeric
) SERVER mongo_server OPTIONS (database 'testdb', collection 'orders');
EOF

# Run the sysbench test for inserting data into MongoDB via PostgreSQL FDW
sysbench oltp_insert \
  --db-driver=pgsql \
  --pgsql-user=postgres \
  --pgsql-password=password \
  --pgsql-db=$DB_NAME \
  --pgsql-host=localhost \
  --pgsql-port=5432 \
  --tables=1 \
  --table-size=$TABLE_SIZE \
  --threads=$NUM_THREADS \
  --time=$TIME \
  --range_size=100 \
  --skip_trx=off \
  --report-interval=10 \
  --index_updates=on \
  --reconnect=on \
  --create_table=off \
  --table_name=$TABLE_NAME \
  run


