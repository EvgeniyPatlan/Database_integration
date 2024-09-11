
#!/bin/bash

# Wait for the containers to fully start
echo "Waiting for the databases to initialize..."
sleep 15

# Set up MySQL FDW in PostgreSQL
docker exec -i percona_postgres psql -U postgres <<EOSQL
CREATE EXTENSION IF NOT EXISTS mysql_fdw;
CREATE SERVER mysql_server FOREIGN DATA WRAPPER mysql_fdw
  OPTIONS (host 'percona_mysql', port '3306');
CREATE USER MAPPING FOR postgres SERVER mysql_server
  OPTIONS (username 'mysql_user', password 'mysql_password');
IMPORT FOREIGN SCHEMA mydb FROM SERVER mysql_server INTO public;
EOSQL

# Set up MongoDB FDW in PostgreSQL
docker exec -i percona_postgres psql -U postgres <<EOSQL
CREATE EXTENSION IF NOT EXISTS mongo_fdw;
CREATE SERVER mongo_server FOREIGN DATA WRAPPER mongo_fdw
  OPTIONS (address 'percona_mongodb', port '27017');
CREATE USER MAPPING FOR postgres SERVER mongo_server
  OPTIONS (username 'mongo_user', password 'mongo_password');
CREATE FOREIGN TABLE mongo_orders (
  order_id INT,
  customer_name TEXT,
  order_date DATE,
  amount NUMERIC
) SERVER mongo_server OPTIONS (database 'testdb', collection 'orders');
EOSQL

echo "FDW setup complete! You can now query MySQL and MongoDB from PostgreSQL."
