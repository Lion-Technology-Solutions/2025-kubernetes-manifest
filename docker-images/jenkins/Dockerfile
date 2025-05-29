# Use the official Jenkins LTS image as base
FROM jenkins/jenkins:lts-jdk17

# Switch to root to install dependencies
USER root

# Install Docker CLI (for DinD), AWS CLI, and other tools
RUN apt-get update && \
    apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws/ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Jenkins plugins (updated list with working plugins)
RUN jenkins-plugin-cli --plugins \
    blueocean \
    docker-workflow \
    pipeline-aws \
    git \
    github \
    sonar \
    kubernetes

# Drop back to the Jenkins user for security
USER jenkins

# Expose Jenkins web UI and agent ports
EXPOSE 8080 50000

# Set Jenkins home directory
ENV JENKINS_HOME /var/jenkins_home

# Health check (optional)
HEALTHCHECK --interval=30s --timeout=5s \
    CMD curl -f http://localhost:8080/login || exit 1

# Start Jenkins
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]