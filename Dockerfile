FROM java

MAINTAINER mohamedmohsen20136412@gmail.com

COPY ./target/netty-example-1.0-SNAPSHOT.jar netty-example-1.0-SNAPSHOT.jar

ENTRYPOINT [ "java","-jar","netty-example-1.0-SNAPSHOT.jar" ]