#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-cicd}"
RELEASE_NAME="${RELEASE_NAME:-jenkins}"
LOCAL_PORT="${LOCAL_PORT:-18080}"
REMOTE_PORT="${REMOTE_PORT:-8080}"
PORT_FORWARD_ADDRESS="${PORT_FORWARD_ADDRESS:-0.0.0.0}"

echo "[INFO] Port-forward Jenkins: http://127.0.0.1:${LOCAL_PORT}"
echo "[INFO] Bind address: ${PORT_FORWARD_ADDRESS}"
kubectl -n "${NAMESPACE}" port-forward --address "${PORT_FORWARD_ADDRESS}" service/"${RELEASE_NAME}" "${LOCAL_PORT}:${REMOTE_PORT}"
