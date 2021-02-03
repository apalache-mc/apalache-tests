#!/usr/bin/env bash
set -euo pipefail

# This script downloads the apalache package of the given version
# and puts it in the _apalache directory for execution

VERSION=${VERSION:-''}

# The directory of this file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ROOT="$DIR"/..

if [ -z "$VERSION" ]
then
    echo "error: must supply a version, e.g., VERSION=v0.0.0 ./use-apalache.sh"
    exit 1
fi

tmp_dir=$(mktemp -d -t "apalache-${VERSION}-XXXXXXXXXX")
zip_name="apalache-v${VERSION}.zip"
dst_dir="${ROOT}/_apalache/apalache-${VERSION}"

cd "$tmp_dir"
wget "https://github.com/informalsystems/apalache/releases/download/v${VERSION}/${zip_name}"
mkdir -p "${dst_dir}"
unzip "${zip_name}" -d "${dst_dir}"
