FROM dockerbarbarians/barbarian-base:unstable

ENV HIVE_USER=hadoop \
    HIVE_LOG_DIR=/var/log/hive \
    HIVE_HOME=/opt/barbarian/hive \
    HIVE_CONF_DIR=/opt/barbarian/hive/conf \
    TEZ_CONF_DIR=/opt/barbarian/tez/conf \
    HIVE_CLASSPATH=$HADOOP_CLASSPATH:/opt/barbarian/hive/lib/* \
    SLIDER_CONF_DIR=/opt/barbarian/slider/conf \
    SLIDER_HOME=/opt/barbarian/slider \
    CONTROL_HOME=/opt/barbarian/control \
    CLASSPATH=$HADOOP_CLASSPATH:/opt/barbarian/hive/lib/*

COPY ./opt/barbarian/control /opt/barbarian/control
COPY ./opt/barbarian/hive /opt/barbarian/hive
# COPY ./opt/barbarian/tez /opt/barbarian/tez
# COPY ./opt/barbarian/slider /opt/barbarian/slider
# COPY ./opt/barbarian/ignite/libs/ignite-*.jar /opt/barbarian/slider/lib/
# COPY ./opt/barbarian/ignite/libs/ignite-hadoop/ignite-*.jar /opt/barbarian/slider/lib/
COPY ./opt/barbarian/tez.tar.gz /opt/barbarian/tez.tar.gz

RUN mkdir -p $HIVE_LOG_DIR \
    && chown -R "$HIVE_USER" $HIVE_LOG_DIR \
    && chgrp -R "$HIVE_USER" $HIVE_LOG_DIR \
    && ln -s /opt/barbarian/hive/conf /etc/hive


# && ln -s /opt/barbarian/tez/conf /etc/tez
#    && ln -s /opt/barbarian/slider/conf /etc/slider
