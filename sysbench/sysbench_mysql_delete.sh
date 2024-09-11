
#!/bin/bash

sysbench oltp_delete   --db-driver=mysql   --mysql-user=mysql_user   --mysql-password=mysql_password   --mysql-host=localhost   --mysql-port=3306   --mysql-db=sysbench_db   --tables=10   --table-size=10000   --threads=8   --time=60   run
