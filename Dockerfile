FROM ubuntu:18.04

USER root
ARG BUILD_HADOOP_VERSION=3.1.2
ARG BUILD_HIVE_VERSION=3.1.2
ARG BUILD_DERBY_VERSION=10.14.2.0
ARG BUILD_HBASE_VERSION=2.2.4

RUN apt-get update -y && apt-get install vim -y && apt-get install wget -y && apt-get install ssh -y && apt-get install openjdk-8-jdk -y && apt-get install sudo -y

COPY ssh_config /etc/ssh/ssh_config

WORKDIR /opt/

COPY /tar/hadoop-${BUILD_HADOOP_VERSION}.tar.gz /opt/
COPY /tar/hive-${BUILD_HIVE_VERSION}.tar.gz /opt/
COPY /tar/derby-${BUILD_DERBY_VERSION}.tar.gz /opt/
COPY /tar/hbase-${BUILD_HBASE_VERSION}.tar.gz /opt/
# RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${BUILD_HADOOP_VERSION}/hadoop-${BUILD_HADOOP_VERSION}.tar.gz
# RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${BUILD_HADOOP_VERSION}/hadoop-${BUILD_HADOOP_VERSION}.tar.gz
# RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${BUILD_HADOOP_VERSION}/hadoop-${BUILD_HADOOP_VERSION}.tar.gz
# RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${BUILD_HADOOP_VERSION}/hadoop-${BUILD_HADOOP_VERSION}.tar.gz

RUN mkdir /opt/hadoop && mkdir /opt/hive && mkdir /opt/derby && mkdir /opt/hbase

RUN tar zxvf /opt/hadoop-${BUILD_HADOOP_VERSION}.tar.gz -C hadoop --strip-components 1 && rm /opt/hadoop-${BUILD_HADOOP_VERSION}.tar.gz
RUN tar zxvf /opt/hive-${BUILD_HIVE_VERSION}.tar.gz -C hive --strip-components 1 && rm /opt/hive-${BUILD_HIVE_VERSION}.tar.gz
RUN tar zxvf /opt/derby-${BUILD_DERBY_VERSION}.tar.gz -C derby --strip-components 1 && rm /opt/derby-${BUILD_DERBY_VERSION}.tar.gz
RUN tar zxvf /opt/hbase-${BUILD_HBASE_VERSION}.tar.gz -C hbase --strip-components 1 && rm /opt/hbase-${BUILD_HBASE_VERSION}.tar.gz

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 0600 ~/.ssh/authorized_keys

RUN mkdir /home/data && mkdir /home/data/dfs && mkdir /home/data/dfs/datanode && mkdir /home/data/dfs/namenode
RUN mkdir /home/zookeeper

RUN mv /opt/hive/lib/log4j-slf4j-impl-2.10.0.jar /opt/hive/lib/log4j-slf4j-impl-2.10.0.jar.bak
RUN mv /opt/hbase/lib/client-facing-thirdparty/slf4j-log4j12-1.7.25.jar /opt/hbase/lib/client-facing-thirdparty/slf4j-log4j12-1.7.25.jar.bak

ENV HDFS_NAMENODE_USER root
ENV HDFS_DATANODE_USER root
ENV HDFS_SECONDARYNAMENODE_USER root
ENV YARN_RESOURCEMANAGER_USER root
ENV YARN_NODEMANAGER_USER root

ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_MAPRED_HOME ${HADOOP_HOME}
ENV HADOOP_COMMON_HOME ${HADOOP_HOME}
ENV HADOOP_HDFS_HOME ${HADOOP_HOME}
ENV YARN_HOME ${HADOOP_HOME}
ENV HADOOP_COMMON_LIB_NATIVE_DIR ${HADOOP_HOME}/lib/native
ENV PATH $PATH:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin

ENV HIVE_HOME /opt/hive
ENV PATH $PATH:${HIVE_HOME}/bin

ENV DERBY_HOME /opt/derby
ENV PATH $PATH:${DERBY_HOME}/bin
ENV CLASSPATH $CLASSPATH:${DERBY_HOME}/lib/derby.jar:${DERBY_HOME}/lib/derbytools.jar

ENV HBASE_HOME /opt/hbase
ENV CLASSPATH $CLASSPATH:${HBASE_HOME}/lib/*
ENV PATH $PATH:${HBASE_HOME}/bin

RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh
COPY /hadoop-conf/core-site.xml ${HADOOP_HOME}/etc/hadoop/
COPY /hadoop-conf/hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/
COPY /hadoop-conf/yarn-site.xml ${HADOOP_HOME}/etc/hadoop/
COPY /hadoop-conf/mapred-site.xml ${HADOOP_HOME}/etc/hadoop/

COPY /hive-conf/hive-env.sh ${HIVE_HOME}/conf/
COPY /hive-conf/hive-site.xml ${HIVE_HOME}/conf/

COPY /hbase-conf/hbase-env.sh ${HBASE_HOME}/conf/
COPY /hbase-conf/hbase-site.xml ${HBASE_HOME}/conf/

COPY docker-entrypoint.sh /home/

WORKDIR /home

EXPOSE 22 9864 8088 9870 10000

ENTRYPOINT ["/home/docker-entrypoint.sh"]