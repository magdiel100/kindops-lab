#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="kindops-lab"

if kind get clusters | grep -qx "$CLUSTER_NAME"; then
  echo "[INFO] Removendo cluster '$CLUSTER_NAME'..."
  kind delete cluster --name "$CLUSTER_NAME"
  echo "[OK] Cluster removido."
else
  echo "[INFO] Cluster '$CLUSTER_NAME' não existe. Nada a fazer."
fi
