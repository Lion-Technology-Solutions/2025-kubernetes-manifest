# Use a minimal Alpine-based OpenJDK image
FROM eclipse-temurin:17-jre-alpine

# Nexus version (check https://help.sonatype.com/repomanager3/download for latest)
ARG NEXUS_VERSION=3.61.0-02
ARG NEXUS_DOWNLOAD_URL=https://download.sonatype.com/nexus/3/nexus-${NEXUS_VERSION}-unix.tar.gz
ARG NEXUS_HOME=/opt/nexus
ARG NEXUS_DATA=/nexus-data

# Create nexus user and group (run as non-root for security)
RUN addgroup -S nexus && \
    adduser -S nexus -G nexus && \
    mkdir -p ${NEXUS_HOME} ${NEXUS_DATA} && \
    chown -R nexus:nexus ${NEXUS_HOME} ${NEXUS_DATA}

# Install prerequisites and Nexus
RUN apk add --no-cache bash su-exec && \
    wget -q ${NEXUS_DOWNLOAD_URL} -O /tmp/nexus.tar.gz && \
    tar -xzf /tmp/nexus.tar.gz -C ${NEXUS_HOME} --strip-components=1 && \
    rm -f /tmp/nexus.tar.gz && \
    sed -i \
      -e "s|karaf.home=.|karaf.home=${NEXUS_HOME}|g" \
      -e "s|karaf.base=.|karaf.base=${NEXUS_HOME}|g" \
      -e "s|karaf.etc=etc|karaf.etc=${NEXUS_HOME}/etc|g" \
      -e "s|java.io.tmpdir=../sonatype-work/nexus3/tmp|java.io.tmpdir=${NEXUS_DATA}/tmp|g" \
      ${NEXUS_HOME}/bin/nexus.vmoptions && \
    ln -s ${NEXUS_DATA} ${NEXUS_HOME}/sonatype-work

# Configure environment
ENV NEXUS_HOME=${NEXUS_HOME} \
    NEXUS_DATA=${NEXUS_DATA} \
    JAVA_MIN_MEM=512M \
    JAVA_MAX_MEM=1024M \
    EXTRA_JAVA_OPTS=""

# Expose ports (HTTP/HTTPS/Docker registry)
EXPOSE 8081 5000

# Health check (ensure Nexus API is responsive)
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:8081/service/metrics/healthcheck || exit 1

# Volume for persistent data
VOLUME ${NEXUS_DATA}

# Copy entrypoint script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Run as nexus user
USER nexus
WORKDIR ${NEXUS_HOME}
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bin/nexus", "run"]