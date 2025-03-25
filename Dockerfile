
# Stage 1: Build the Java app
FROM maven:3.9.6-openjdk-17 AS build

WORKDIR /app

# Copy pom.xml and install dependencies first
COPY pom.xml .

# Download all dependencies (without building the app)
RUN mvn dependency:go-offline

# Copy the source code and compile
COPY src /app/src
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/*.jar /app/myapp.jar

# Expose the port the app will run on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "/app/myapp.jar"]
