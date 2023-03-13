# shellcheck shell=bash

if [ -z "$DISABLE_ATMOS_ALIASES" ] ; then
    alias adsc=atmos-describe-stack-component
    alias agscv=atmos-get-stack-component-var
    alias alcd=atmos-list-component-directories
fi
