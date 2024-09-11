
#!/bin/bash

sysbench oltp_insert   --db-driver=mysql   --mysql-user=mysql_user   --mysql-password=mysql_password   --mysql-host=$1   --mysql-port=3306   --mysql-db=mydb   --tables=10   --table-size=10000   --threads=8   --time=60   run
