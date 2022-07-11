FROM openjdk
COPY target/*.jar /
EXPOSE 8080
ENTRYPOINT ["java","-jar","/hello-world-1.0.1-SNAPSHOT.jar"]