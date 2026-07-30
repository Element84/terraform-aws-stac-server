#!/usr/bin/env bash

# Download the lambda dist ZIP asset from a stac-server GitHub release.
#
# The asset name embeds the Node.js version it was built with (e.g.
# stac-server-lambda-dist_v5.0.0_node-v22.22.1.zip), so the release is queried
# via the GitHub API rather than constructing the asset URL directly.
#
# Set GITHUB_TOKEN to authenticate the API request (avoids the low
# unauthenticated rate limit).
#
# Usage:
#
#     ./utils/fetch-lambda-dist.bash vX.Y.Z /path/to/output.zip

set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 STAC_SERVER_VERSION OUTPUT_PATH"
    exit 1
fi

version="$1"
output_path="$2"

auth_args=()
if [ -n "${GITHUB_TOKEN:-}" ]; then
    auth_args=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
fi

release_url="https://api.github.com/repos/stac-utils/stac-server/releases/tags/${version}"
asset_url=$(
    curl -s -L --fail "${auth_args[@]}" "$release_url" |
        jq -r '[.assets[] | select(.name | startswith("stac-server-lambda-dist"))][0].browser_download_url // empty'
)

if [ -z "$asset_url" ]; then
    echo "ERROR: no lambda dist ZIP asset found on stac-server release ${version}."
    echo "Releases prior to v5.0.0 do not include this asset. Build a ZIP locally"
    echo "(npm run build-lambda-dist) and set stac_server_zip_filepath instead."
    exit 1
fi

echo "Downloading ${asset_url} to ${output_path}..."
curl -s -L --fail -o "$output_path" "$asset_url"
