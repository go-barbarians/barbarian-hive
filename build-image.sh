#!/bin/bash
#
# prerequisite - SSH access to github
#              - Membership Barbarians team with read access to github
#              - Ubuntu 16.04 LTS

CONTAINER_REPO=535272059665.dkr.ecr.eu-west-1.amazonaws.com

HADOOP_VERSION=2.8.4
HIVE_BRANCH_VERSION=3.1 #currently labelled 3.1.0 in the dist
HIVE_RELEASE_VERSION=3.1.0
TEZ_BRANCH_VERSION=0.9
TEZ_RELEASE_VERSION=0.9.2-SNAPSHOT
IGNITE_BRANCH_VERSION=2.6
IGNITE_RELEASE_VERSION=2.5.0-SNAPSHOT #todo: change to release
PACKAGING_DIR=opt/barbarian

WORKING_DIR=`dirname $(readlink -f $0)`
TEMP_DIR=/work/temp #your choice here

mkdir -p $WORKING_DIR/$PACKAGING_DIR
mkdir -p $TEMP_DIR

pushd $TEMP_DIR

# build prerequisites
sudo apt-get -y install maven build-essential autoconf automake libtool cmake zlib1g-dev pkg-config libssl-dev libfuse-dev \
snappy libsnappy-dev autogen

# build protoc
wget https://github.com/protocolbuffers/protobuf/archive/v2.5.0.tar.gz
tar xzf v2.5.0.tar.gz
pushd ./protobuf-2.5.0
curl -L https://github.com/google/googletest/archive/release-1.5.0.tar.gz | tar zx
mv googletest-release-1.5.0 gtest
./autogen.sh
./configure
make
make check
sudo make install
sudo ldconfig
popd

# build hadoop
git clone git@github.com:go-barbarians/badh-hadoop.git
pushd ./badh-hadoop
git checkout branch-$HADOOP_VERSION
mvn clean package install -Pdist -Pnative -Drequire.snappy -Dbundle.snappy \
-Drequire.openssl -Dbundle.openssl -DskipTests=true \
-Dsnappy.lib=/usr/lib/x86_64-linux-gnu -Dopenssl.lib=/usr/lib/x86_64-linux-gnu

cp -R hadoop-dist/target/hadoop-$HADOOP_VERSION $WORKING_DIR/$PACKAGING_DIR/hadoop
#delete config directory
rm -rf $WORKING_DIR/$PACKAGING_DIR/hadoop/etc/hadoop
popd

# build hive
git clone git@github.com:go-barbarians/badh-hive.git
pushd ./badh-hive
git checkout branch-$HIVE_BRANCH_VERSION
mvn clean package install -DskipTests=true -Pdist
cp -R packaging/target/apache-hive-$HIVE_RELEASE_VERSION-bin/apache-hive-$HIVE_RELEASE_VERSION-bin $WORKING_DIR/$PACKAGING_DIR/hive
#delete config directory
rm -rf $WORKING_DIR/$PACKAGING_DIR/hive/conf
popd

# build ignite
# nb. ignite is a prereq for tez because need to bundle ignite JARs in tez application tarball
# nb. ignite-mesos module breaks the build and must be commented in pom.xml
# nb. two patches need to be applied
git clone git@github.com:go-barbarians/badh-ignite.git
pushd ./badh-ignite
#wget https://issues.apache.org/jira/secure/attachment/12939077/IGNITE-9473.patch
#wget https://issues.apache.org/jira/secure/attachment/12939078/IGNITE-9504.patch
#patch -p2 < IGNITE-9473.patch
#patch -p2 < IGNITE-9504.patch
git checkout ignite-$IGNITE_BRANCH_VERSION
mvn clean package install -Prelease -Dignite.edition=hadoop -DskipTests -Dhadoop.version=$HADOOP_VERSION
cp -R target/release-package-hadoop $WORKING_DIR/$PACKAGING_DIR/ignite
#delete config directory
rm -rf $WORKING_DIR/$PACKAGING_DIR/ignite/config
popd

# build tez
# nb. tez does some crazy stuff with Node.JS - definitely don't build behind an http proxy!!
git clone git@github.com:go-barbarians/badh-tez.git
pushd ./badh-tez
git checkout branch-$TEZ_BRANCH_VERSION
mvn clean package -DskipTests=true -Dmaven.javadoc.skip=true -Dhadoop.version=$HADOOP_VERSION -Dhive.version=$HIVE_RELEASE_VERSION
cp -R tez-dist/target/tez-$TEZ_RELEASE_VERSION $WORKING_DIR/$PACKAGING_DIR/tez
cp $WORKING_DIR/$PACKAGING_DIR/ignite-$IGNITE_RELEASE_VERSION/ignite-*.jar $WORKING_DIR/$PACKAGING_DIR/tez/lib
cp $WORKING_DIR/$PACKAGING_DIR/ignite-$IGNITE_RELEASE_VERSION/ignite-hadoop/ignite-*.jar $WORKING_DIR/$PACKAGING_DIR/tez/lib
pushd $WORKING_DIR/$PACKAGING_DIR/tez
tar cf tez.tar .
gzip tez.tar
mv tez.tar.gz ..
popd
#delete config directory
rm -rf $WORKING_DIR/$PACKAGING_DIR/tez/conf
popd

# build slider
git clone git@github.com:go-barbarians/badh-slider.git
pushd ./badh-slider
sudo apt-get install -y python2.7

MAVEN_OPTS=-Xms256m -Xmx512m -Djava.awt.headless=true
export HADOOP_VERSION=2.8.4
mvn clean package install -DskipTests=true
mvn site:site site:stage package -DskipTests=true
cp -R slider-assembly/target/slider-0.92.0-incubating-all/slider-0.92.0-incubating $WORKING_DIR/$PACKAGING_DIR/slider
#delete config directory
rm -rf $WORKING_DIR/$PACKAGING_DIR/slider/conf
popd
popd #back to working directory

sudo $(aws ecr get-login --no-include-email --region eu-west-1)
sudo docker build -t hive .
sudo docker tag hive:latest $CONTAINER_REPO/hive:latest
sudo docker push $CONTAINER_REPO/hive:latest

