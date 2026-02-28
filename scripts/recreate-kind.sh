#!/usr/bin/env bash
set -euo pipefail

./scripts/destroy-kind.sh
./scripts/bootstrap-kind.sh
