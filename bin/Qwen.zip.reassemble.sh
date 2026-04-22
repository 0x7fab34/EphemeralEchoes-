#!/bin/bash
set -euo pipefail
BASE=$(basename "$0" .reassemble.sh)
echo "🔧 Reassembling ${BASE} from parts..."
cat ${BASE}.part* > ${BASE}.reassembled
if [ -f ${BASE}.sha256 ]; then
    echo "🔍 Verifying checksum..."
    EXPECTED=$(cat ${BASE}.sha256)
    ACTUAL=$(sha256sum ${BASE}.reassembled | awk '{print $1}')
    if [ "$EXPECTED" != "$ACTUAL" ]; then
        echo "❌ Checksum mismatch! File may be corrupted."
        rm ${BASE}.reassembled
        exit 1
    fi
    echo "✅ Checksum OK"
fi
mv ${BASE}.reassembled ${BASE}
echo "🎉 Reassembly complete: ${BASE}"
