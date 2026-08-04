#!/usr/bin/env bash

# Build the historical-ingest module's lambda ZIP from its Python source and
# requirements. The resulting modules/historical-ingest/lambda.zip is committed
# to this repository.
#
# Usage (from the repository root):
#
#     ./utils/build-historical-ingest.bash

set -euo pipefail

# Must match runtime in modules/historical-ingest/lambda.tf; AWS defaults the
# unset architectures to x86_64.
LAMBDA_PYTHON_VERSION="3.10"
LAMBDA_PLATFORM="manylinux2014_x86_64"

if [ ! -d "modules/historical-ingest/lambda" ]; then
    echo "ERROR: run this script from the repository root"
    exit 1
fi

rm -f modules/historical-ingest/lambda.zip

cd modules/historical-ingest/lambda
rm -rf package

# Cross-build for the Lambda platform, not the build host. --only-binary fails
# if a dependency has no matching wheel rather than compiling one for the host.
pip install -r requirements.txt --target package \
    --platform "$LAMBDA_PLATFORM" \
    --python-version "$LAMBDA_PYTHON_VERSION" \
    --implementation cp \
    --only-binary=:all: \
    --no-compile

cd package
zip -r ../../lambda.zip .
cd ..
zip ../lambda.zip main.py
rm -rf package
cd ../../..

if [ ! -f "modules/historical-ingest/lambda.zip" ]; then
    echo "ERROR: modules/historical-ingest/lambda.zip was not created"
    exit 1
fi

# A wrong-platform binary would otherwise surface as an ImportError at runtime.
wrong_platform=$(unzip -l modules/historical-ingest/lambda.zip \
    | grep '\.so$' \
    | grep -v 'x86_64-linux-gnu' || true)
if [ -n "$wrong_platform" ]; then
    echo "ERROR: lambda.zip contains extensions not built for linux/x86_64:"
    echo "$wrong_platform"
    exit 1
fi

echo "Done!"
