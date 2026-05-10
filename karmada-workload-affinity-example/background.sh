#!/usr/bin/env bash
# Runs silently while the user reads the intro.
# Installs Karmada v1.17 with three member clusters and enables the
# WorkloadAffinity feature gate in the karmada-scheduler.
set -euo pipefail

KARMADA_ROOT=/root/karmada
KARMADA_APISERVER_KUBECONFIG=/etc/karmada/karmada-apiserver.config
HOST_KUBECONFIG=/root/.kube/karmada-host.config

log() { echo "[background] $*"; }

# ── Idempotency guard ────────────────────────────────────────────────────────
if command -v kubectl &>/dev/null \
   && [ -f "$KARMADA_APISERVER_KUBECONFIG" ] \
   && kubectl --kubeconfig "$KARMADA_APISERVER_KUBECONFIG" get clusters &>/dev/null 2>&1; then
  log "Karmada already set up — skipping."
  exit 0
fi

# ── System dependencies ──────────────────────────────────────────────────────
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y \
  curl git wget conntrack socat \
  apt-transport-https ca-certificates gnupg lsb-release

# ── Docker ───────────────────────────────────────────────────────────────────
if ! command -v docker &>/dev/null; then
  curl -fsSL https://get.docker.com | sh
fi
systemctl start docker 2>/dev/null || true

# ── Go 1.21 ──────────────────────────────────────────────────────────────────
GO_VERSION=1.21.5
if ! command -v go &>/dev/null; then
  wget -q "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
  tar -C /usr/local -xzf /tmp/go.tar.gz
  rm /tmp/go.tar.gz
fi
export GOROOT=/usr/local/go
export GOPATH=/root/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# ── kubectl ──────────────────────────────────────────────────────────────────
if ! command -v kubectl &>/dev/null; then
  KUBECTL_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
  curl -fsSLo /usr/local/bin/kubectl \
    "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
  chmod +x /usr/local/bin/kubectl
fi

# ── kind ─────────────────────────────────────────────────────────────────────
if ! command -v kind &>/dev/null; then
  curl -fsSLo /usr/local/bin/kind \
    "https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64"
  chmod +x /usr/local/bin/kind
fi

# ── Clone Karmada v1.17.0 ────────────────────────────────────────────────────
if [ ! -d "$KARMADA_ROOT/.git" ]; then
  git clone --depth 1 --branch v1.17.0 \
    https://github.com/karmada-io/karmada.git "$KARMADA_ROOT"
fi

# ── Run local-up-karmada.sh ──────────────────────────────────────────────────
cd "$KARMADA_ROOT"
hack/local-up-karmada.sh

# ── Enable WorkloadAffinity feature gate in karmada-scheduler ────────────────
# local-up-karmada.sh creates a kind cluster called "karmada-host" where the
# Karmada control-plane pods live.
if kind get clusters 2>/dev/null | grep -q "^karmada-host$"; then
  kind get kubeconfig --name karmada-host > "$HOST_KUBECONFIG" 2>/dev/null

  # Only patch if the flag is not already present
  EXISTING=$(kubectl --kubeconfig "$HOST_KUBECONFIG" \
    -n karmada-system get deployment karmada-scheduler \
    -o jsonpath='{.spec.template.spec.containers[0].command}' 2>/dev/null || echo "")

  if ! echo "$EXISTING" | grep -q "WorkloadAffinity"; then
    kubectl --kubeconfig "$HOST_KUBECONFIG" \
      -n karmada-system patch deployment karmada-scheduler \
      --type=json \
      -p='[{"op":"add","path":"/spec/template/spec/containers/0/command/-","value":"--feature-gates=WorkloadAffinity=true"}]'

    kubectl --kubeconfig "$HOST_KUBECONFIG" \
      -n karmada-system rollout status deployment/karmada-scheduler \
      --timeout=120s || true
  fi
fi

log "Setup complete. WorkloadAffinity feature gate is active."
