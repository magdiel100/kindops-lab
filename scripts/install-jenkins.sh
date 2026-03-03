#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="${NAMESPACE:-cicd}"
RELEASE_NAME="${RELEASE_NAME:-jenkins}"
VALUES_FILE="${VALUES_FILE:-infra/jenkins/values.yaml}"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "[ERRO] Comando obrigatorio nao encontrado: $1"
    exit 1
  fi
}

for cmd in kubectl helm; do
  require_cmd "$cmd"
done

echo "[INFO] Instalando/atualizando Jenkins no namespace '${NAMESPACE}'..."
kubectl get ns "${NAMESPACE}" >/dev/null 2>&1 || kubectl create ns "${NAMESPACE}"

helm repo add jenkins https://charts.jenkins.io >/dev/null
helm repo update >/dev/null

helm upgrade --install "${RELEASE_NAME}" jenkins/jenkins \
  --namespace "${NAMESPACE}" \
  -f "${VALUES_FILE}" \
  --wait \
  --timeout 10m

echo "[INFO] Aguarde a inicializacao do controller..."
if ! kubectl -n "${NAMESPACE}" rollout status statefulset/"${RELEASE_NAME}" --timeout=10m; then
  echo "[ERRO] Jenkins nao ficou pronto. Coletando diagnostico..."
  kubectl -n "${NAMESPACE}" get pods -o wide || true
  kubectl -n "${NAMESPACE}" describe pod "${RELEASE_NAME}-0" || true
  kubectl -n "${NAMESPACE}" logs "${RELEASE_NAME}-0" -c init --tail=200 || true
  kubectl -n "${NAMESPACE}" logs "${RELEASE_NAME}-0" -c init --previous --tail=200 || true
  exit 1
fi

echo "[OK] Jenkins pronto."
echo "[INFO] Usuario: admin"
echo "[INFO] Senha (secret):"
kubectl -n "${NAMESPACE}" get secret "${RELEASE_NAME}" -o jsonpath='{.data.jenkins-admin-password}' | base64 -d
echo
