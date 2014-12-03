#!/bin/sh

if [ "$1" = "tomcat" ] ; then
  chown -R tomcat:tomcat /opt
  exec gosu tomcat:tomcat /opt/tomcat/bin/catalina.sh run
fi

exec "$@"

