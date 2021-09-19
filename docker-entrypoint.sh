#!/bin/bash

echo "[SERVER] starting ssh services"
sudo service ssh start

echo "[SERVER] check if namenode is formatted"
if [ ! -d "/home/data/dfs/namenode/current" ]
        then
                hdfs namenode -format
                echo "[SERVER] done formatting namenode"
        else
                echo "[SERVER] namenode is already formatted"
fi

echo "[SERVER] staring hadoop services (dfs & yarn)"
start-dfs.sh
start-yarn.sh

echo "[SERVER] starting derby server"
nohup startNetworkServer -h localhost &

echo "[SERVER] starting hbase server"
start-hbase.sh

echo "[SERVER] check if /tmp dir exist on hdfs"
hadoop fs -test -d /tmp
if [ $? != 0 ]
        then
                echo "[SERVER] creating /tmp dir on hdfs"
                hadoop fs -mkdir -p /tmp
                hadoop fs -chmod 733 /tmp
        else
                echo "[SERVER] /tmp dir is exist on hdfs"
fi

echo "[SERVER] check if /hive/warehouse dir exist on hdfs"
hadoop fs -test -d /hive/warehouse
if [ $? != 0 ]
        then
                echo "[SERVER] creating /hive/warehouse dir on hdfs"
                hadoop fs -mkdir -p /hive
                hadoop fs -mkdir -p /hive/warehouse
                hadoop fs -chmod 733 /hive/warehouse
                echo "[SERVER] applying derby init schema"
                schematool -dbType derby -initSchema
        else
                echo "[SERVER] /hive/warehouse dir is exist on hdfs"
fi

echo "[SERVER] Server is ready to be used! :D, Here are running services:"
jps

bash