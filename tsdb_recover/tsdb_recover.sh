#!/bin/bash

while true
do
    echo 0
    kubectl cp ./ts.sql tsdb-mysql-0:/home/ts.sql -c mysql
    kubectl exec tsdb-mysql-0 -c mysql -- /bin/bash -c "mysql < /home/ts.sql"
    echo 1
    kubectl cp ./ts.sql tsdb-mysql-1:/home/ts.sql -c mysql
    kubectl exec tsdb-mysql-1 -c mysql -- /bin/bash -c "mysql < /home/ts.sql"
    echo 2
    kubectl cp ./ts.sql tsdb-mysql-2:/home/ts.sql -c mysql
    kubectl exec tsdb-mysql-2 -c mysql -- /bin/bash -c "mysql < /home/ts.sql"
    echo `date`
    sleep 600
done
