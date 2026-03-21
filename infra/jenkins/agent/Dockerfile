FROM maven:3.9.9-eclipse-temurin-17

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
  python3 \
  python3-venv \
  python3-pip \
  git \
  docker.io \
  curl \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/jenkins/agent && chown -R 1000:1000 /home/jenkins

USER 1000
WORKDIR /home/jenkins/agent
