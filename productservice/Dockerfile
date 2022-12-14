FROM maven:3.8.6-openjdk-11 AS build
COPY . .
RUN mvn -f productservice/pom.xml clean package -DskipTests

FROM openjdk:11
COPY --from=build productservice/target/productservice-0.0.1-SNAPSHOT.jar /usr/local/lib/productservice-0.0.1-SNAPSHOT.jar
#ADD productservice/target/productservice-0.0.1-SNAPSHOT.jar productservice-0.0.1-SNAPSHOT.jar
ENTRYPOINT [ "java", "-jar", "/usr/local/lib/productservice-0.0.1-SNAPSHOT.jar" ]