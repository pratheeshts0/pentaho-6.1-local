from ubuntu:14.04
maintainer pratheesh
run apt-get update && apt-get -y upgrade \
	&& echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
	&& apt-get install -y python-software-properties software-properties-common \
	&& add-apt-repository -y ppa:webupd8team/java \
	&& apt-get -y update \
	&& apt-get install -y nano wget unzip locate oracle-java8-installer libmysql-java git \
	&& update-java-alternatives --set java-8-oracle \
	&& apt-get install oracle-java8-set-default && java -version \
workdir /opt/pentaho

workdir /opt/pentaho
#run wget http://sourceforge.net/projects/pentaho/files/Business%20Intelligence%20Server/6.1/biserver-ce-6.1.0.1-196.zip
add biserver-ce-6.1.0.1-196.zip /opt/pentaho/
run unzip biserver-ce-6.1.0.1-196.zip

env host 192.168.1.234

workdir /opt/pentaho
run git clone https://github.com/pratheeshts0/pentaho-6.1-local.git




run cp /opt/pentaho/biserver-ce/tomcat/lib/postgresql-9.3-1102-jdbc4.jar /usr/share/java/ \
	&& ln -s  /usr/share/java/postgresql-9.3-1102.jdbc4.jar  /usr/share/java/postgresql-9.3-jdbc4.jar \
	&& ln -s  /usr/share/java/postgresql-9.3-1102.jdbc4.jar  /opt/pentaho/biserver-ce/tomcat/lib/postgresql-9.3-jdbc4.jar


#Change Pentaho settings for using PostgreSQL database for backend
#Change the pentaho tomcat context.xml file (/opt/pentaho/biserver-ce/tomcat/webapps/pentaho/META-INF/context.xml)

run sed -i s/"org.hsqldb.jdbcDriver"/"org.postgresql.Driver"/g /opt/pentaho/biserver-ce/tomcat/webapps/pentaho/META-INF/context.xml \
	&& sed -i s/"jdbc:hsqldb:hsql:\/\/localhost\/hibernate"/"jdbc:postgresql:\/\/$host:5432\/hibernate"/g /opt/pentaho/biserver-ce/tomcat/webapps/pentaho/META-INF/context.xml \
	&& sed -i s/"select count(\*) from INFORMATION_SCHEMA.SYSTEM_SEQUENCES"/"select 1"/g /opt/pentaho/biserver-ce/tomcat/webapps/pentaho/META-INF/context.xml \
	&& sed -i s/"org.hsqldb.jdbcDriver"/"org.postgresql.Driver"/g /opt/pentaho/biserver-ce/tomcat/webapps/pentaho/META-INF/context.xml \
	&& sed -i s/"jdbc:hsqldb:hsql:\/\/localhost\/quartz"/"jdbc:postgresql:\/\/$host:5432\/quartz"/g /opt/pentaho/biserver-ce/tomcat/webapps/pentaho/META-INF/context.xml \
	&& sed -i s/"select count(\*) from INFORMATION_SCHEMA.SYSTEM_SEQUENCES"/"select 1"/g /opt/pentaho/biserver-ce/tomcat/webapps/pentaho/META-INF/context.xml




#Change the hibernate config files (/opt/pentaho/biserver-ce/pentaho-solutions/system/applicationContext-spring-security-hibernate.properties)

run sed -i s/"org.hsqldb.jdbcDriver"/"org.postgresql.Driver"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/applicationContext-spring-security-hibernate.properties \
	&& sed -i s/"jdbc:hsqldb:hsql:\/\/localhost:9001\/hibernate"/"jdbc:postgresql:\/\/$host:5432\/hibernate"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/applicationContext-spring-security-hibernate.properties




#Change the hibernate config files (/opt/pentaho/biserver-ce/pentaho-solutions/system/hibernate/hibernate-settings.xml)

run sed -i s/"system\/hibernate\/hsql.hibernate.cfg.xml"/"system\/hibernate\/postgresql.hibernate.cfg.xml"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/hibernate/hibernate-settings.xml


run sed -i s"|jdbc:postgresql://localhost:5432/hibernate|jdbc:postgresql://$host:5432/hibernate|"g /opt/pentaho/biserver-ce/pentaho-solutions/system/hibernate/postgresql.hibernate.cfg.xml




#Change the hibernate config files (/opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties)

run sed -i s/"SampleData\/type=javax.sql.DataSource"/"#SampleData\/type=javax.sql.DataSource"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"SampleData\/driver=org.hsqldb.jdbcDriver"/"#SampleData\/driver=org.hsqldb.jdbcDriver"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"SampleData\/url=jdbc:hsqldb:hsql:\/\/localhost\/sampledata"/"#SampleData\/url=jdbc:hsqldb:hsql:\/\/localhost\/sampledata"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"SampleData\/user=pentaho_user"/"#SampleData\/user=pentaho_user"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"SampleData\/password=password"/"#SampleData\/password=password"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"Hibernate\/driver=org.hsqldb.jdbcDriver"/"Hibernate\/driver=org.postgresql.Driver"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"Hibernate\/url=jdbc:hsqldb:hsql:\/\/localhost\/hibernate"/"Hibernate\/url=jdbc:postgresql:\/\/$host:5432\/hibernate"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"Quartz\/driver=org.hsqldb.jdbcDriver"/"Quartz\/driver=org.postgresql.Driver"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"Quartz\/url=jdbc:hsqldb:hsql:\/\/localhost\/quartz"/"Quartz\/url=jdbc:postgresql:\/\/$host:5432\/quartz"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"Shark\/type=javax.sql.DataSource"/"#Shark\/type=javax.sql.DataSource"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"Shark\/driver=org.hsqldb.jdbcDriver"/"#Shark\/driver=org.hsqldb.jdbcDriver"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"Shark\/url=jdbc:hsqldb:hsql:\/\/localhost\/shark"/"#Shark\/url=jdbc:hsqldb:hsql:\/\/localhost\/shark"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"Shark\/user=sa"/"#Shark\/user=sa"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"Shark\/password="/"#Shark\/password="/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"SampleDataAdmin\/type=javax.sql.DataSource"/"#SampleDataAdmin\/type=javax.sql.DataSource"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"SampleDataAdmin\/driver=org.hsqldb.jdbcDriver"/"#SampleDataAdmin\/driver=org.hsqldb.jdbcDriver"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"SampleDataAdmin\/url=jdbc:hsqldb:hsql:\/\/localhost\/sampledata"/"#SampleDataAdmin\/url=jdbc:hsqldb:hsql:\/\/localhost\/sampledata"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"SampleDataAdmin\/user=pentaho_admin"/"#SampleDataAdmin\/user=pentaho_admin"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties \
	&& sed -i s/"SampleDataAdmin\/password=password"/"#SampleDataAdmin\/password=password"/g /opt/pentaho/biserver-ce/pentaho-solutions/system/simple-jndi/jdbc.properties


#Edit the file /your/path/to/biserver-ce/pentaho-solutions/system/applicationContext-spring-security-jdbc.xml

run mv /opt/pentaho/biserver-ce/pentaho-solutions/system/applicationContext-spring-security-jdbc.xml /opt/pentaho/biserver-ce/pentaho-solutions/system/applicationContext-spring-security-jdbc.xml1 \
	&& cp /opt/pentaho/pentaho-6.1-local/applicationContext-spring-security-jdbc.xml /opt/pentaho/biserver-ce/pentaho-solutions/system/ 

run sed -i s"|jdbc:postgresql://localhost:5432/hibernate|jdbc:postgresql://$host:5432/hibernate|"g /opt/pentaho/biserver-ce/pentaho-solutions/system/applicationContext-spring-security-jdbc.xml




#Edit the file /opt/pentaho/biserver-ce/tomcat/webapps/pentaho/WEB-INF/web.xml to prevent HSQLDB to start

run rm /opt/pentaho/biserver-ce/tomcat/webapps/pentaho/WEB-INF/web.xml \
	&& cp /opt/pentaho/pentaho-6.1-local/web.xml /opt/pentaho/biserver-ce/tomcat/webapps/pentaho/WEB-INF/



expose 8080
entrypoint /opt/pentaho/biserver-ce/start-pentaho.sh \
	&& tailf /opt/pentaho/biserver-ce/tomcat/logs/catalina.out \
	&& bash

