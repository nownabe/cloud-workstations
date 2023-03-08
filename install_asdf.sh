#!/bin/bash

set -o pipefail
set -o errexit
set -o nounset

# plugins and default version to install

declare -A plugins=(
  ["bat"]="latest"
  ["buf"]="latest"
  ["direnv"]="latest"
  ["fzf"]="latest"
  ["ghq"]="latest"
  ["go-sdk"]=""
  ["hey"]="latest"
  ["java"]="temurin-17.0.6+10"
  ["jq"]="latest"
  ["nodejs"]="lts"
  ["poetry"]="latest"
  ["protoc"]="latest"
  ["python"]=""
  ["ripgrep"]="latest"
  ["ruby"]="latest"
  ["terraform"]="latest"
)

git clone https://github.com/asdf-vm/asdf.git /root/.asdf --branch "v$ASDF_VERSION"

. /root/.asdf/asdf.sh

for plugin in "${!plugins[@]}"; do
  echo "** Installing ${plugin} **"
  asdf plugin add "${plugin}"

  if [[ ! -z "${plugins[${plugin}]}" ]]; then
    asdf list all "${plugin}" >/dev/null # nodejs lts needs this
    asdf install "${plugin}" "${plugins[${plugin}]}"
    asdf global "${plugin}" "${plugins[${plugin}]}"
  fi
done
