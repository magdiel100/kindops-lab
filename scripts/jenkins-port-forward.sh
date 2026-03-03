#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-cicd}"
RELEASE_NAME="${RELEASE_NAME:-jenkins}"
LOCAL_PORT="${LOCAL_PORT:-8080}"
REMOTE_PORT="${REMOTE_PORT:-8080}"

echo "[INFO] Port-forward Jenkins: http://127.0.0.1:${LOCAL_PORT}"
kubectl -n "${NAMESPACE}" port-forward service/"${RELEASE_NAME}" "${LOCAL_PORT}:${REMOTE_PORT}"
