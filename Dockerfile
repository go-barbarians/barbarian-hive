FROM dockerbarbarians/gpl-free-base-image:latest

ENV HIVE_USER=hadoop \
    HIVE_LOG_DIR=/var/log/hive \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    HADOOP_HOME=/opt/barbarian/hadoop \
    HIVE_HOME=/opt/barbarian/hive \
    HADOOP_CONF_DIR=/opt/barbarian/hadoop/etc/hadoop \
    YARN_CONF_DIR=/opt/barbarian/hadoop/etc/hadoop \
    HIVE_CONF_DIR=/opt/barbarian/hive/conf \
    TEZ_CONF_DIR=/opt/barbarian/tez/conf \
    HADOOP_CLASSPATH=/opt/barbarian/hadoop/etc/hadoop:/opt/barbarian/hadoop/share/hadoop/common/lib/*:/opt/barbarian/hadoop/share/hadoop/common/*:/opt/barbarian/hadoop/share/hadoop/yarn/*:/opt/barbarian/hadoop/share/hadoop/yarn/lib/*:/opt/barbarian/tez/conf:/opt/barbarian/hive/lib/*:/opt/barbarian/tez/lib/*:/opt/barbarian/tez/* \
    HIVE_CLASSPATH=$HADOOP_CLASSPATH \
    SLIDER_CONF_DIR=/opt/barbarian/slider/conf \
    SLIDER_HOME=/opt/barbarian/slider \
    CONTROL_HOME=/opt/barbarian/control

#RUN apt-get update && \
#    apt-get install -y openjdk-8-jre-headless python2.7 openssl locales ca-certificates-java wget
#RUN apt-get clean && \
#    update-ca-certificates -f && \
#    rm -rf /var/lib/apt/lists/*

#RUN ln -s /usr/bin/python2.7 /usr/bin/python
RUN ln -s /opt/python27/bin/python /usr/bin/python
RUN mkdir -p /opt/barbarian

COPY ./opt/barbarian/control /opt/barbarian/control
COPY ./opt/barbarian/hadoop /opt/barbarian/hadoop
COPY ./opt/barbarian/hive /opt/barbarian/hive
# COPY ./opt/barbarian/tez /opt/barbarian/tez
# COPY ./opt/barbarian/slider /opt/barbarian/slider
COPY ./opt/barbarian/ignite/libs/ignite-*.jar /opt/barbarian/hadoop/share/hadoop/common/lib/
COPY ./opt/barbarian/ignite/libs/ignite-hadoop/ignite-*.jar /opt/barbarian/hadoop/share/hadoop/common/lib/
# COPY ./opt/barbarian/ignite/libs/ignite-*.jar /opt/barbarian/slider/lib/
# COPY ./opt/barbarian/ignite/libs/ignite-hadoop/ignite-*.jar /opt/barbarian/slider/lib/
COPY ./opt/barbarian/tez.tar.gz /opt/barbarian/tez.tar.gz

# RUN wget -O /opt/barbarian/hive/lib/mariadb-jdbc.jar https://downloads.mariadb.com/Connectors/java/connector-java-2.3.0/mariadb-java-client-2.3.0.jar

RUN echo "hadoop:!::0:::::" >> /etc/shadow
RUN echo "hadoop:!::0:::::" >> /etc/shadow
RUN echo "hadoop:x:1000:hadoop" >> /etc/group
RUN echo "hadoop:x:1000:1000:hadoop:/home/hadoop:/bin/mksh" >> /etc/passwd

RUN mkdir -p $HIVE_LOG_DIR \
    && mkdir -p /grid/0 \
    && mkdir -p /home/$HIVE_USER \
    && chown -R "$HIVE_USER:$HIVE_USER" $HIVE_LOG_DIR \
    && chown -R "$HIVE_USER:$HIVE_USER" /grid/0 \
    && chown -R "$HIVE_USER:$HIVE_USER" /home/$HIVE_USER \
    && ln -s /opt/barbarian/hive/conf /etc/hive \
    && ln -s /opt/barbarian/hadoop/etc/hadoop /etc/hadoop \
    && ln -s /opt/barbarian/tez/conf /etc/tez

#    && ln -s /opt/barbarian/slider/conf /etc/slider
