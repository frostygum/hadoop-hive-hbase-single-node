# Hadoop Hive Hbase Single Node

Please be sure you already have docker installed and uncheck "Use Docker Compose V2 release candidate" at docker preferences > experimental features.

### First Run or Rebuild Docker Image: 
    docker-compose up -d --build

### Normal Run: 
    docker-compose start

### Stop container: 
    docker-compose stop

### Delete container: 
    docker-compose down

### Connect to container: 
    docker exec -it hadoop-hive-hbase bash

### Delete container: 
    docker-compose down

## Succesfull Output
Be sure you are getting like similar like this:
    hadoop-hive-hbase | [SERVER] Server is ready to be used! :D, Here are running services:
    hadoop-hive-hbase | 1841 HMaster
    hadoop-hive-hbase | 434 DataNode
    hadoop-hive-hbase | 1426 NetworkServerControl
    hadoop-hive-hbase | 931 ResourceManager
    hadoop-hive-hbase | 1076 NodeManager
    hadoop-hive-hbase | 2010 HRegionServer
    hadoop-hive-hbase | 267 NameNode
    hadoop-hive-hbase | 653 SecondaryNameNode
    hadoop-hive-hbase | 1774 HQuorumPeer
    hadoop-hive-hbase | 2959 Jps
