# shellcheck shell=bash

if [ -z "$DISABLE_ATMOS_ALIASES" ] ; then
    function atmos-describe-stack-component(){
        local usage component flags;
        usage="Usage: atmos-describe-stack-component <component> [flags: defaults to '--sections=none']"
        component=${1?$usage}
        flags=${2:---sections=none}
        atmos describe stacks --components "$component" "$flags"
    }
    alias adsc=atmos-describe-stack-component
fi
