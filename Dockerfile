FROM grossws/java7
MAINTAINER Konstantin Gribov <grossws@gmail.com>

ADD tomcat-8.0.14.tar.gz /opt/
CMD /opt/tomcat/bin/catalina.sh run

