#!/usr/bin/env bash
set -euo pipefail

REGISTRY_HOST="${REGISTRY_HOST:-host.docker.internal:5000}"
IMAGE_NAME="${IMAGE_NAME:-jenkins-agent-ci}"
IMAGE_TAG="${IMAGE_TAG:-latest}"

IMAGE_REF="${REGISTRY_HOST}/${IMAGE_NAME}:${IMAGE_TAG}"

echo "[INFO] Building ${IMAGE_REF}"
docker build -t "${IMAGE_REF}" -f infra/jenkins/agent/Dockerfile .

echo "[INFO] Pushing ${IMAGE_REF}"
docker push "${IMAGE_REF}"

echo "[OK] Agent image ready: ${IMAGE_REF}"
