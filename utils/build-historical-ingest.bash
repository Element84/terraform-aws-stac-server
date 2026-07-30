#!/usr/bin/env bash

# Build the historical-ingest module's lambda ZIP from its Python source and
# requirements. The resulting modules/historical-ingest/lambda.zip is committed
# to this repository.
#
# Usage (from the repository root):
#
#     ./utils/build-historical-ingest.bash

set -euo pipefail

rm -f modules/historical-ingest/lambda.zip

cd modules/historical-ingest/lambda
pip install -r requirements.txt --target package
cd package
zip -r ../../lambda.zip .
cd ..
zip ../lambda.zip main.py
cd ../..

if [ ! -f "lambda.zip" ]; then
    echo "ERROR: modules/historical-ingest/lambda.zip was not created"
    exit 1
fi

echo "Done!"
