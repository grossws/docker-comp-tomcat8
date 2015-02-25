#!/bin/sh

if [ "$1" = "tomcat" ] ; then
  chown -R tomcat:tomcat /opt
  export JAVA_OPTS="-Dxhost=$HOSTNAME -Dxtype=${XTYPE:-TOMCAT} $JAVA_OPTS"
  exec gosu tomcat:tomcat /opt/tomcat/bin/catalina.sh run
fi

exec "$@"

