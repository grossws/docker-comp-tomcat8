FROM grossws/java7
MAINTAINER Konstantin Gribov <grossws@gmail.com>

ENV CATALINA_HOME /opt/tomcat

RUN groupadd -r tomcat \
	&& useradd -r --create-home -g tomcat tomcat \
	&& yum install -y tar

# $CATALINA_HOME impicitly created adding these files
ADD logging.properties $CATALINA_HOME/
ADD server.xml $CATALINA_HOME/

RUN chown -R tomcat:tomcat /opt

WORKDIR $CATALINA_HOME
USER tomcat

# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN gpg --keyserver pgp.mit.edu --recv-keys \
	05AB33110949707C93A279E3D3EFE6B686867BA6 \
	07E48665A34DCAFAE522E5E6266191C37C037D42 \
	47309207D818FFD8DCD3F83F1931D684307A10A5 \
	541FBE7D8F78B25E055DDEE13C370389288584E7 \
	61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
	79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
	9BA44C2621385CB966EBA586F72C284D731FABEE \
	A27677289986DB50844682F8ACB77FC2E86E29AC \
	A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
	DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
	F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
	F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.15
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN curl -SL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& curl -SL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
	&& gpg --verify tomcat.tar.gz.asc \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& mkdir -p conf/Catalina/localhost \
	&& rm -f bin/*.bat \
	&& rm -rf webapps/* \
	&& rm tomcat.tar.gz* \
	&& mv logging.properties server.xml $CATALINA_HOME/conf/

CMD ["/opt/tomcat/bin/catalina.sh", "run"]

