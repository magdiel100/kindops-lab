#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="kindops-lab"
KUBE_CONTEXT="kind-${CLUSTER_NAME}"

./scripts/destroy-kind.sh
./scripts/bootstrap-kind.sh

echo "[INFO] Exportando kubeconfig para o cluster '${CLUSTER_NAME}'..."
kind export kubeconfig --name "${CLUSTER_NAME}"

echo "[INFO] Definindo contexto kubectl para '${KUBE_CONTEXT}'..."
kubectl config use-context "${KUBE_CONTEXT}" >/dev/null

echo "[OK] Recreate concluido com kubeconfig/contexto atualizados."
