#!/usr/bin/env bash
set -euo pipefail

CLUSTER_NAME="kindops-lab"
KIND_CONFIG="infra/kind/kind-config.yaml"
NAMESPACES=(cicd argocd observability istio-system apps)
CONTROL_PLANE_CPUS="${CONTROL_PLANE_CPUS:-1.0}"
CONTROL_PLANE_MEMORY="${CONTROL_PLANE_MEMORY:-1536m}"
WORKER_CPUS="${WORKER_CPUS:-1.0}"
WORKER_MEMORY="${WORKER_MEMORY:-2048m}"
KUBECTL_RETRIES="${KUBECTL_RETRIES:-12}"
KUBECTL_RETRY_SLEEP="${KUBECTL_RETRY_SLEEP:-5}"
KIND_CREATE_RETRIES="${KIND_CREATE_RETRIES:-3}"
KIND_CREATE_RETRY_SLEEP="${KIND_CREATE_RETRY_SLEEP:-10}"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "[ERRO] Comando obrigatório não encontrado: $1"
    exit 1
  fi
}

kubectl_retry() {
  local attempt=1
  local max="${KUBECTL_RETRIES}"

  until kubectl "$@"; do
    if [ "${attempt}" -ge "${max}" ]; then
      echo "[ERRO] kubectl falhou após ${max} tentativas: kubectl $*"
      return 1
    fi
    echo "[WARN] kubectl ainda indisponível (tentativa ${attempt}/${max}). Aguardando ${KUBECTL_RETRY_SLEEP}s..."
    attempt=$((attempt + 1))
    sleep "${KUBECTL_RETRY_SLEEP}"
  done
}

apply_node_limits() {
  local control_plane="${CLUSTER_NAME}-control-plane"
  local worker="${CLUSTER_NAME}-worker"

  echo "[INFO] Aplicando limites de recursos nos nós do kind..."
  echo "       control-plane: cpus=${CONTROL_PLANE_CPUS}, memory=${CONTROL_PLANE_MEMORY}"
  echo "       worker:        cpus=${WORKER_CPUS}, memory=${WORKER_MEMORY}"

  docker update \
    --cpus "${CONTROL_PLANE_CPUS}" \
    --memory "${CONTROL_PLANE_MEMORY}" \
    --memory-swap "${CONTROL_PLANE_MEMORY}" \
    "${control_plane}" >/dev/null

  docker update \
    --cpus "${WORKER_CPUS}" \
    --memory "${WORKER_MEMORY}" \
    --memory-swap "${WORKER_MEMORY}" \
    "${worker}" >/dev/null
}

create_cluster_with_retry() {
  local attempt=1
  local max="${KIND_CREATE_RETRIES}"

  while [ "${attempt}" -le "${max}" ]; do
    echo "[INFO] Criando cluster '${CLUSTER_NAME}'... (tentativa ${attempt}/${max})"
    if kind create cluster --name "${CLUSTER_NAME}" --config "${KIND_CONFIG}"; then
      echo "[OK] Cluster criado com sucesso."
      return 0
    fi

    echo "[WARN] Falha ao criar cluster na tentativa ${attempt}."
    echo "[INFO] Limpando tentativa parcial..."
    kind delete cluster --name "${CLUSTER_NAME}" >/dev/null 2>&1 || true

    if [ "${attempt}" -lt "${max}" ]; then
      echo "[INFO] Aguardando ${KIND_CREATE_RETRY_SLEEP}s antes de nova tentativa..."
      sleep "${KIND_CREATE_RETRY_SLEEP}"
    fi

    attempt=$((attempt + 1))
  done

  echo "[ERRO] Não foi possível criar o cluster após ${max} tentativas."
  return 1
}

echo "[INFO] Validando pré-requisitos..."
for cmd in docker kubectl kind helm; do
  require_cmd "$cmd"
done

echo "[INFO] Versões detectadas"
docker --version
kubectl version --client
kind version
helm version --short

if kind get clusters | grep -qx "$CLUSTER_NAME"; then
  echo "[INFO] Cluster '$CLUSTER_NAME' já existe. Pulando criação."
else
  create_cluster_with_retry
fi

apply_node_limits

echo "[INFO] Aguardando API do Kubernetes ficar estável..."
kubectl_retry get --raw=/readyz >/dev/null

echo "[INFO] Criando namespaces base..."
for ns in "${NAMESPACES[@]}"; do
  kubectl get ns "$ns" >/dev/null 2>&1 || kubectl_retry create namespace "$ns"
done

echo "[INFO] Instalando ingress-nginx via Helm..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx >/dev/null
helm repo update >/dev/null
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.replicaCount=1 \
  --set controller.metrics.enabled=false \
  --set controller.resources.requests.cpu=100m \
  --set controller.resources.requests.memory=128Mi \
  --set controller.resources.limits.cpu=300m \
  --set controller.resources.limits.memory=256Mi

echo "[INFO] Estado do cluster"
kubectl get nodes

echo "[INFO] Namespaces"
kubectl get ns

echo "[INFO] Pods ingress-nginx"
kubectl -n ingress-nginx get pods

echo "[OK] Bootstrap local concluído."
