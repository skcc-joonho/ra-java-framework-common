# Build stage
FROM gradle:8.5.0-jdk17 AS build
WORKDIR /app

# Copy SSL certificate and add to Java truststore
COPY SK_SSL.crt /tmp/SK_SSL.crt
RUN keytool -import -noprompt -trustcacerts -alias sk-ssl -file /tmp/SK_SSL.crt -keystore $JAVA_HOME/lib/security/cacerts -storepass changeit

# Copy Gradle wrapper
COPY gradlew .
COPY gradle ./gradle
COPY gradlew.bat .
RUN chmod +x gradlew

# Copy settings.gradle and build.gradle first
COPY settings.gradle .
COPY build.gradle .
COPY gradle.properties .

# Copy all modules
COPY common-export ./common-export
COPY account-export ./account-export
COPY account-service ./account-service

# Build the project
RUN ./gradlew :account-service:bootJar --no-daemon

# Run stage
FROM eclipse-temurin:17-jre-jammy
LABEL maintainer="joonho.park@sk.com"
LABEL version="1.0.0"
LABEL description="Account Service Application"

WORKDIR /app
COPY --from=build /app/account-service/build/libs/*.jar app.jar

# Set timezone
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Expose port
EXPOSE 8080

# Run the application with Spring profile
ENTRYPOINT ["java", "-Dspring.profiles.active=dev", "-jar", "app.jar"] 