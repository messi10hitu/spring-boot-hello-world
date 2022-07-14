FROM openjdk
ADD target/hello-world-1.0.1-SNAPSHOT.jar hello-world-1.0.1-SNAPSHOT.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/hello-world-1.0.1-SNAPSHOT.jar"]