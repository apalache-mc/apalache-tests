#!/usr/bin/env bash
set -euo pipefail

for tag in $@
do
    docker pull apalache/mc:"$tag"
done
