FROM ubuntu:16.04

ENV HS2_USER=hive \
    HS2_LOG_DIR=/var/log/hive \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    HADOOP_HOME=/hadoop \
    HIVE_HOME=/hive \
    HADOOP_CONF_DIR=/hadoop/etc/hadoop \
    YARN_CONF_DIR=/hadoop/etc/hadoop \
    HIVE_CONF_DIR=/hive/conf \
    TEZ_CONF_DIR=/tez/conf \
    HADOOP_CLASSPATH=/hadoop/etc/hadoop:/hadoop/share/hadoop/common/lib/*:/hadoop/share/hadoop/common/*:/hadoop/share/hadoop/yarn/*:/hadoop/share/hadoop/yarn/lib/*:/tez/conf:/hive/lib/*:/tez/lib/*:/tez/*:/hadoop/share/hadoop/yarn/*:/hadoop/share/hadoop/yarn/lib/* \
    HIVE_CLASSPATH=$HADOOP_CLASSPATH \
    SLIDER_CONF_DIR=/slider/conf \
    SLIDER_HOME=/slider
    CONTROL_HOME=/control

RUN apt-get update && \
    apt-get install -y openjdk-8-jre-headless
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:fkrull/deadsnakes && \
    apt-get update && \
    apt-get install -y python2.6 && \
    apt-get install -y openssl && \
    apt-get -y install locales && \
    rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python2.6 /usr/bin/python

COPY ./control /control
COPY ./hadoop /hadoop
COPY ./hive /hive
COPY ./tez /tez
COPY ./slider /slider
COPY ./templates /templates
COPY ./ignite/libs/ignite-*.jar /hadoop/share/hadoop/common/lib/
COPY ./ignite/libs/ignite-hadoop/ignite-*.jar /hadoop/share/hadoop/common/lib/
COPY ./ignite/libs/ignite-*.jar /slider/lib/
COPY ./ignite/libs/ignite-hadoop/ignite-*.jar /slider/lib/


RUN set -x \
    && useradd $HS2_USER \
    && [ `id -u $HS2_USER` -eq 1000 ] \
    && [ `id -g $HS2_USER` -eq 1000 ] \
    && mkdir -p $HS2_LOG_DIR /usr/share/hive /usr/etc/ \
    && chown -R "$HS2_USER:$HS2_USER" $HS2_LOG_DIR \
    && ln -s /hive/conf/ /usr/etc/hive
