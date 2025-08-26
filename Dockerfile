# Stage 1: Build with Maven
FROM maven:3.9.4-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests
 
# Stage 2: Run app
FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY --from=builder /app/target/myapp-1.0-SNAPSHOT.jar /app/myapp.jar
CMD ["java", "-jar", "myapp.jar"]
