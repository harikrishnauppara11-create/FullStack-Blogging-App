# Use Eclipse Temurin JDK 17 Alpine base image
FROM eclipse-temurin:17-jdk-alpine

# Set working directory inside container
WORKDIR /app

# Create app directory and set permissions
RUN mkdir -p /usr/src/app && \
    addgroup -S spring && \
    adduser -S spring -G spring && \
    chown -R spring:spring /usr/src/app

# Set environment variables
ENV APP_HOME=/usr/src/app
ENV JAVA_OPTS=""

# Switch to non-root user for security
USER spring

# Expose application port
EXPOSE 8080

# Copy the application JAR file
# Make sure there's only one JAR file in your target directory
COPY --chown=spring:spring target/twitter-app-*.jar app.jar

# Set entry point to run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar app.jar"]

# Health check (optional)
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1
