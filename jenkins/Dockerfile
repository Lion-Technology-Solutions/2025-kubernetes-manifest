# Use official Jenkins LTS image as base
FROM jenkins/jenkins:lts-jdk17

# Switch to root to install dependencies
USER root

# Install essential tools (adjust based on your needs)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    docker.io \           # For Docker-in-Docker (DinD)
    python3 \
    python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install kubectl (for Kubernetes integration)
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Switch back to jenkins user
USER jenkins

# Pre-install plugins (comma-separated list)
ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
RUN jenkins-plugin-cli --plugins \
    blueocean \
    pipeline-aws \
    kubernetes \
    docker-workflow \
    git \
    github \
    sonar \
    slack \
    ws-cleanup

# Copy custom configuration files
COPY --chown=jenkins:jenkins jenkins.yaml /usr/share/jenkins/ref/casc.yaml
COPY --chown=jenkins:jenkins init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

# Environment variables
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Djava.awt.headless=true"
ENV CASC_JENKINS_CONFIG="/usr/share/jenkins/ref/casc.yaml"

# Expose web interface and agent port
EXPOSE 8080 50000

# Health check
HEALTHCHECK --interval=30s --timeout=5s \
    CMD curl -f http://localhost:8080/login || exit 1

# Volume for persistent data
VOLUME /var/jenkins_home