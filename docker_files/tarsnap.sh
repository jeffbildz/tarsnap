#!/bin/bash

# ###############################################################################
# CONFIGURATION
# ###############################################################################
CONF=/root/tarsnapper.conf

# ###############################################################################
# FUNCTIONS
# ###############################################################################
function log {
    echo `date +%F\ %T`: "$@"
}

function failed {
    log "backup generation FAILED: Line: $1, Code: $2"
    exit $2
}

# ###############################################################################
# ENVIRONMENT
# ###############################################################################
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

trap 'failed ${LINENO} ${$?}' ERR

exec 2>&1

# ###############################################################################
# MAIN
# ###############################################################################
log "backup generation START"
tarsnapper -c $CONF make
log "backup generation DONE"