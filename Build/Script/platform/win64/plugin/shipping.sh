#!/usr/bin/env bash
# HorizonTweenDemo - Build ONLY HorizonTweenPlugin (not all plugins)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Source the shared subst-aware Build/Base layer.
source "${SCRIPT_DIR}/../../../../Base/Script/common.sh"

HOST_PLATFORM="${HOST_PLATFORM:-Win64}"
TARGET_PLATFORM="${TARGET_PLATFORM:-Win64}"
TARGET_CONFIGURATION="${TARGET_CONFIGURATION:-Shipping}"

# Override build_find_plugins to only return HorizonTweenPlugin.
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
