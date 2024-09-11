
#!/bin/bash

sysbench oltp_delete   --db-driver=pgsql   --pgsql-user=postgres   --pgsql-password=password   --pgsql-host=$1   --pgsql-port=5432   --pgsql-db=postgres   --tables=10   --table-size=10000   --threads=8   --time=60   run
