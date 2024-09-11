
#!/bin/bash

sysbench oltp_delete   --db-driver=pgsql   --pgsql-user=postgres   --pgsql-password=password   --pgsql-host=localhost   --pgsql-port=5432   --pgsql-db=sysbench_db   --tables=10   --table-size=10000   --threads=8   --time=60   run
