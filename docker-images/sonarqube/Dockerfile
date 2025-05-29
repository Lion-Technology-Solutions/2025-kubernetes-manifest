# Use the official SonarQube image as base
FROM sonarqube:community

# Switch to root for system modifications (if needed)
USER root

# Install any additional dependencies (example: curl for health checks)
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Copy custom plugins (optional)
# COPY plugins/* /opt/sonarqube/extensions/plugins/

# Copy custom configuration (optional)
# COPY sonar.properties /opt/sonarqube/conf/sonar.properties

# Switch back to the sonarqube user (for security)
USER sonarqube

# Health check (optional)
HEALTHCHECK --interval=30s --timeout=10s \
  CMD curl -f http://localhost:9000 || exit 1

# Expose the default SonarQube port
EXPOSE 9000

# Start SonarQube
CMD ["/opt/sonarqube/bin/run.sh"]