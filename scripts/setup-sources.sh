#!/usr/bin/env bash

# A quick and dirty script to prepare the source code needed for
# the apalache bench tests

set -euf -o pipefail

unreleased="0.7.0"
devl_dir="${HOME}/devl"

mkdir -p "$devl_dir"
git clone git@github.com:informalsystems/apalache.git "$devl_dir/apalache" > /dev/null

for v in "0.5.2" "0.6.0" "0.7.0"
do
    echo "preparing source code for apalache version ${v}"
    version_dir="${HOME}/devl/apalache-${v}"
    cp -r "${devl_dir}/apalache" "$version_dir"
    pushd "$version_dir"
    git fetch
    if [[ "$v" == "$unreleased" ]]
    then
        branch="origin/unstable"
    else
        branch="tags/v${v}"
    fi
    git checkout "$branch"
    echo "source code for apalache version ${v} is available in ${version_dir}"
    popd
done
