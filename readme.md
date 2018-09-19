# Barbarian big data system
Barbarian is the world's best cloud-first, cloud-agnostic big data system founded on Apache Hadoop for enterprise-ready parallel distributed data processing at scale.

Read more at:
[https://barbarians.io/](https://barbarians.io)

## Hive Docker image

This repo contains the configuration files and build scripts for the Barbarian Hadoop **Hive Docker image**.

The latest release of the Hive Docker image is based on the following Apache Foundation software releases:
- Apache Hadoop 2.8.4
- Apache Hive 3.1.0
- Apache Ignite 2.6 (patched)
- Apache Tez 0.9.2
- Apache Slider 0.6

## Releases

| Release | Notes |
| -- | -- |
| 0.1-INTERNAL | Prelease PoC for demo |
| -- | -- |

## Building

Just run the buildscript @ ```$WORKING_DIR/build-image.sh```

## Running

This image is designed to be run as a part of the Barbarian Hadoop distribution - a Kubernetes based platform for data processing at scale, founded on free software developed by the [Apache Software Foundation](https://www.apache.org/).

Launching this image is done using [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) and the provided [yaml](http://yaml.org) configuration file (see in the directory ./yaml). Successful deployment depends on:
- A running Kubernetes cluster with sufficient resource to deploy the full platform
- A running ZooKeeper ensemble
- A running and configured MySQL database server (automation, move to PostgreSQL and automated initialization/upgrade will come)
- A running Ignite IGFS cluster
- An AWS S3 bucket and associated (AWS IAM restricted) access keys
- An (internal, firewalled) webserver that hosts the access keys
- A running YARN ResourceManager
- A running cluster of YARN NodeManagers

Launch a 3-node Hive metastore cluster with ```kubectl create -f yaml/metastore.yaml```  

Launch a 4-node LLAP cluster with ```kubectl create -f yaml/hiveserver2.yaml```

*** please ensure that you set up the necessary secrets files and use the secrets setup script in the repo [barbarian-tooling](https://github.com/go-barbarians/barbarian-tooling) or the Metastore's database will not be accessible ***
*** please ensure that you initialize an RDS instance using ```hive/bin/schematool -init``` or the Metastore's database will not be useable ***

## Features

The image includes support for the following Hive features:
- An initpod to launch Hive LLAP daemons (low latency analytics processing aka live long and process) on the cluster
- An initpod to wait for the Hive LLAPd service to come up
- Apache Tez execution engine
- Standalone Metastore in HA
- Hiveserver2

## What's still to do

- Support for LDAP, kerberos & Apache Ranger will follow


