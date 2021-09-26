#!/bin/sh

DIR="${BLOCK_INSTANCE:-/}"
ALERT_LOW="${1:-10}" # color will turn red under this value (default: 10%)

df -h -P -l "$DIR" | awk -v alert_low=$ALERT_LOW '
/\/.*/ {
    # full text
    print $4

    # short text
    print $4

    use=$5

    # no need to continue parsing
    exit 0
}

END {
    gsub(/%$/,"",use)
    if (100 - use < alert_low) {
        # color
        print "#FF0000"
    }
}
'
