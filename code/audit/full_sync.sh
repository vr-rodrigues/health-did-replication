#!/bin/bash
# Legacy wrapper kept for users who previously ran code/audit/full_sync.sh.
# The single maintained sync path is now code/audit/sync_final_outputs.R.

set -euo pipefail

cd "$(dirname "$0")/../.."
Rscript code/audit/sync_final_outputs.R
