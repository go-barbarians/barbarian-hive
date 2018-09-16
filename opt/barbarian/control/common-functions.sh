function mk_log_dir() {
  mkdir -p $LOG_DIR
}

function process_file() {
  rm -f $TARGET_PATH/$TARGET_FILE
  echo "Creating $TARGET_PATH/$TARGET_FILE configuration"

  #Strip whitespace
  HMS_DB_USERNAME=$(echo $HMS_DB_USERNAME | xargs)
  HMS_DB_PASSWORD=$(echo $HMS_DB_PASSWORD | xargs)
  HMS_DB_URI=$(echo $HMS_DB_URI | xargs)

  TEMPLATE=`cat /opt/barbarian/templates/$TARGET_PATH/$TARGET_FILE.template`
  TEMPLATE="${TEMPLATE//zzzLOG_LEVELzzz/$LOG_LEVEL}"
  TEMPLATE="${TEMPLATE//zzzLOG_DIRzzz/$LOG_DIR}"
  TEMPLATE="${TEMPLATE//zzzHMS_DB_URIzzz/$HMS_DB_URI}"
  TEMPLATE="${TEMPLATE//zzzHMS_DB_USERNAMEzzz/$HMS_DB_USERNAME}"
  TEMPLATE="${TEMPLATE//zzzHMS_DB_PASSWORDzzz/$HMS_DB_PASSWORD}"
  TEMPLATE="${TEMPLATE//zzzHMS_CONNECTzzz/$HMS_CONNECT}"
  TEMPLATE="${TEMPLATE//zzzZK_CONNECTzzz/$ZK_CONNECT}"
  TEMPLATE="${TEMPLATE//zzzRM_CONNECTzzz/$RM_CONNECT}"
  TEMPLATE="${TEMPLATE//zzzIGFS_CONNECTzzz/$IGFS_CONNECT}"
  TEMPLATE="${TEMPLATE//zzzCONF_DIRzzz/$HADOOP_CONF_DIR}"
  TEMPLATE="${TEMPLATE//zzzHIVE_USERzzz/$USER}"
  echo "$TEMPLATE" >> $TARGET_PATH/$TARGET_FILE
}

function create_beeline_log4j() {
  TARGET_PATH=$HIVE_CONF_DIR
  TARGET_FILE=$BEELINE_LOG4J_FILE
  process_file
}

function create_config_mapred_site() {
  TARGET_PATH=$HADOOP_CONF_DIR
  TARGET_FILE=$MAPRED_SITE_FILE
  process_file
}

function create_config_hive_site() {
  TARGET_PATH=$HIVE_CONF_DIR
  TARGET_FILE=$HIVE_SITE_FILE
  process_file
}

function create_config_tez_site() {
  TARGET_PATH=$TEZ_CONF_DIR
  TARGET_FILE=$TEZ_SITE_FILE
  process_file
}

function create_config_core_site() {
  TARGET_PATH=$HADOOP_CONF_DIR
  TARGET_FILE=$CORE_SITE_FILE
  process_file
}

function create_config_yarn_site() {
  TARGET_PATH=$HADOOP_CONF_DIR
  TARGET_FILE=$YARN_SITE_FILE
  process_file
}

function create_hadoop_env() {
  rm -f $HADOOP_CONF_DIR/$HADOOP_ENV_FILE
  echo "Creating hadoop-env configuration"
  echo "\
export HADOOP_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
" >> $HADOOP_CONF_DIR/$HADOOP_ENV_FILE
}

function create_hive_log4j() {
  TARGET_PATH=$HIVE_CONF_DIR
  TARGET_FILE=$HIVE_LOG4J_FILE
  process_file
}

function create_hadoop_log4j() {
  TARGET_PATH=$HADOOP_CONF_DIR
  TARGET_FILE=$HADOOP_LOG4J_FILE
  process_file
}

TEZ_SITE_FILE="tez-site.xml"
HIVE_SITE_FILE="hive-site.xml"
CORE_SITE_FILE="core-site.xml"
YARN_SITE_FILE="yarn-site.xml"
MAPRED_SITE_FILE="mapred-site.xml"
HADOOP_LOG4J_FILE="log4j.properties"
HIVE_LOG4J_FILE="hive-log4j2.properties"
BEELINE_LOG4J_FILE="beeline-log4j2.properties"
HADOOP_ENV_FILE="hadoop-env.sh"

export HADOOP_CLASSPATH=$HADOOP_CLASSPATH
export HIVE_CLASSPATH=$HADOOP_CLASSPATH
