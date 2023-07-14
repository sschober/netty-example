FROM tomcat

MAINTAINER mohamedmohsen

COPY ./target/netty-example-1.0-SNAPSHOT.jar /var/lib/tomcat7/webapps/netty-example-1.0-SNAPSHOT.jar


