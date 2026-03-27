#!/usr/bin/env bash
# HorizonTweenDemo - Build ONLY HorizonTweenPlugin for Win64
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/../../../../Build/Base/Script/common.sh"

HOST_PLATFORM="${HOST_PLATFORM:-Win64}"
TARGET_PLATFORM="${TARGET_PLATFORM:-Win64}"
TARGET_CONFIGURATION="${TARGET_CONFIGURATION:-Shipping}"

build_find_plugins() {
    local project_root="${1:-$(build_project_root)}"
    if [[ -f "${project_root}/Plugins/HorizonTweenPlugin/HorizonTweenPlugin.uplugin" ]]; then
        printf '%s\n' "${project_root}/Plugins/HorizonTweenPlugin/HorizonTweenPlugin.uplugin"
    else
        echo "ERROR: HorizonTweenPlugin not found at ${project_root}/Plugins/HorizonTweenPlugin/HorizonTweenPlugin.uplugin" >&2
        return 1
    fi
}

build_run_plugin "$@"
