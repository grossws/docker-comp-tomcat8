FROM grossws/java
MAINTAINER Konstantin Gribov <grossws@gmail.com>

ENV CATALINA_HOME /opt/tomcat

RUN groupadd -r tomcat \
  && useradd -r --create-home -g tomcat tomcat

# $CATALINA_HOME impicitly created adding these files
ADD entrypoint.sh server.xml logging.properties $CATALINA_HOME/

WORKDIR $CATALINA_HOME

# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN gpg --keyserver pgp.mit.edu --recv-keys \
  79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
  05AB33110949707C93A279E3D3EFE6B686867BA6 \
  A27677289986DB50844682F8ACB77FC2E86E29AC \
  47309207D818FFD8DCD3F83F1931D684307A10A5 \
  61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
  07E48665A34DCAFAE522E5E6266191C37C037D42 \
  DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
  A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
  541FBE7D8F78B25E055DDEE13C370389288584E7 \
  F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
  9BA44C2621385CB966EBA586F72C284D731FABEE \
  F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.35
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN NEAREST_TOMCAT_TGZ_URL=$(curl -sSL http://www.apache.org/dyn/closer.cgi/${TOMCAT_TGZ_URL#https://www.apache.org/dist/}\?asjson\=1 \
    | awk '/"path_info": / { pi=$2; }; /"preferred":/ { pref=$2; }; END { print pref " " pi; };' \
    | sed -r -e 's/^"//; s/",$//; s/" "//') \
  && echo "Nearest mirror: $NEAREST_TOMCAT_TGZ_URL" \
  && curl -sSL "$NEAREST_TOMCAT_TGZ_URL" -o tomcat.tar.gz \
  && curl -sSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
  && gpg --verify tomcat.tar.gz.asc tomcat.tar.gz \
  && tar -xvf tomcat.tar.gz --strip-components=1 \
  && mkdir -p conf/Catalina/localhost \
  && rm -f bin/*.bat \
  && rm -rf webapps/* \
  && rm tomcat.tar.gz* \
  && mv logging.properties server.xml $CATALINA_HOME/conf/ \
  && mv $CATALINA_HOME/entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tomcat"]

