#!/bin/sh
# Srun encryption and encoding functions

srun_md5() {
    echo -n "$1" | md5sum | awk '{print $1}'
}

srun_base64() {
    echo -n "$1" | base64 | tr -d '\n'
}

srun_encode() {
    local data="$1"
    # Simple base64 encoding for info parameter
    # In production, this should implement the actual Srun encoding algorithm
    srun_base64 "$data"
}

srun_xencode() {
    local msg="$1"
    local key="$2"
    # XOR encoding (simplified version)
    # In production, this should implement the actual Srun xencode algorithm
    echo -n "$msg"
}

srun_sha1() {
    echo -n "$1" | openssl dgst -sha1 -binary | xxd -p | tr -d '\n'
}

# Export functions
export -f srun_md5
export -f srun_base64
export -f srun_encode
export -f srun_xencode
export -f srun_sha1
