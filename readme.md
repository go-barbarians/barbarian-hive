# Barbarian Hadoop distribution

[https://barbarians.io/](https://barbarians.io)

## Hive Docker image

This repo contains the configuration files and build scripts for the Barbarian Hadoop **Hive Docker image**.

The latest release of the Hive Docker image is based on the following Apache Foundation software releases:
- Apache Hadoop 2.8.4
- Apache Hive
- Apache Ignite 2.6 (patched)
- Apache Tez 0.9.2
- Apache Slider 0.6
- Apache Zookeeper

## Releases

| Release | Notes |
| -- | -- |
| 0.1-INTERNAL | Prelease PoC for demo |
| -- | -- |

## Building

**todo:** buildscripts missing

## Running

This image is designed to be run as a part of the Barbarian Hadoop distribution - a Kubernetes based platform for data processing at scale, founded on free software developed by the [Apache Software Foundation](https://www.apache.org/).

Launching this image is done using [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) and the provided [yaml](http://yaml.org) configuration file. Successful deployment depends on:
- A running Kubernetes cluster with sufficient resource to deploy the full platform
- A running ZooKeeper ensemble
- A running and configured MySQL database server (automation, move to PostgreSQL and automated initialization/upgrade will come)
- A running Ignite IGFS cluster
- An AWS S3 bucket and associated (AWS IAM restricted) access keys
- An (internal, firewalled) webserver that hosts the access keys
- A running YARN ResourceManager
- A running cluster of YARN NodeManagers

## Features

The image includes support for the following Hive features:
- An initpod to launch Hive LLAP daemons (low latency analytics processing aka live long and process) on the cluster
- Apache Tez execution engine
- Support for dedicated Metastore and Apache Ranger will follow


