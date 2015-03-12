#!/bin/sh

if [ "$1" = "tomcat" ] ; then
  chown -R tomcat:tomcat /opt
  export CATALINA_OPTS="-Dxhost=$HOSTNAME -Dxtype=${XTYPE:-tomcat} $CATALINA_OPTS"
  exec gosu tomcat:tomcat /opt/tomcat/bin/catalina.sh run
fi

exec "$@"

