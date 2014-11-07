#!/bin/bash

TOMCAT_VERSION=8.0.14

if [ -d tomcat ] ; then
  echo "output directory \"tomcat\" exists"
  exit 1
fi

if [ ! -f apache-tomcat-${TOMCAT_VERSION}.tar.gz ] ; then
  echo "download apache tomcat ${TOMCAT_VERSION} to current dir"
  exit 1
fi

tar xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz

mv apache-tomcat-8.0.14 tomcat
mkdir -p tomcat/conf/Catalina/localhost
cp logging.properties server.xml tomcat/conf/
rm -rf tomcat/bin/*.bat tomcat/bin/tomcat-native.tar.gz tomcat/webapps/*

tar -czf tomcat-${TOMCAT_VERSION}.tar.gz --sort=name --owner=root --group=root --mtime="2014-09-29 00:00:00Z" tomcat/
rm -rf tomcat

