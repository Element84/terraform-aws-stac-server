#!/usr/bin/env bash

# Download the lambda dist ZIP asset from a stac-server GitHub release.
#
# The asset name embeds the Node.js version it was built with (e.g.
# stac-server-lambda-dist_v5.0.0_node-v22.22.1.zip), so the release is queried
# via the GitHub API rather than constructing the asset URL directly.
#
# Usage:
#
#     ./utils/fetch-lambda-dist.bash vX.Y.Z /path/to/output.zip
#
# Set GITHUB_TOKEN to raise the GitHub API rate limit from 60 requests/hour
# per IP to 5000.

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

# --fail suppresses the body on error, so capture the status separately to tell
# a missing release apart from a rate limit.
response=$(curl -s -L -w '\n%{http_code}' "${auth_args[@]}" "$release_url") || {
    echo "ERROR: could not reach the GitHub API at ${release_url}" >&2
    exit 1
}
http_code="${response##*$'\n'}"
release_json="${response%$'\n'*}"

case "$http_code" in
    200) ;;
    404)
        echo "ERROR: stac-server has no release tagged ${version}." >&2
        echo "Check stac_server_version against https://github.com/stac-utils/stac-server/releases" >&2
        exit 1
        ;;
    403 | 429)
        echo "ERROR: GitHub API rate limit hit while resolving release ${version}." >&2
        echo "Set GITHUB_TOKEN to raise the limit from 60 requests/hour to 5000." >&2
        exit 1
        ;;
    *)
        echo "ERROR: GitHub API returned HTTP ${http_code} for release ${version}." >&2
        exit 1
        ;;
esac

asset_url=$(
    jq -r '[.assets[] | select(.name | startswith("stac-server-lambda-dist"))][0].browser_download_url // empty' <<<"$release_json"
)

if [ -z "$asset_url" ]; then
    echo "ERROR: no lambda dist ZIP asset found on stac-server release ${version}." >&2
    echo "Releases prior to v5.0.0 do not include this asset. Build a ZIP locally" >&2
    echo "(npm run build-lambda-dist) and set stac_server_lambda_zip_filepath instead." >&2
    exit 1
fi

echo "Downloading ${asset_url} to ${output_path}..."
curl -s -L --fail -o "$output_path" "$asset_url" || {
    echo "ERROR: failed to download the lambda dist ZIP from ${asset_url}" >&2
    exit 1
}
