FROM openjdk:11
#COPY --from=build productservice/target/productservice-0.0.1-SNAPSHOT.jar /usr/local/lib/productservice-0.0.1-SNAPSHOT.jar
ADD productservice/target/productservice-0.0.1-SNAPSHOT.jar productservice-0.0.1-SNAPSHOT.jar
ENTRYPOINT [ "java", "-jar", "productservice-0.0.1-SNAPSHOT.jar" ]