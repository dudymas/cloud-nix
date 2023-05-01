# shellcheck shell=bash

function atmos-describe-stack-component(){
    local usage component flags;
    usage='
    Usage: atmos-describe-stack-component <component> [flags: defaults to "--sections=none"]

    This function will return the description of the specified component of any stack
    that atmos can associate with it.
    '
    component=${1?"$usage"}
    flags=${2:---sections=none}
    atmos describe stacks --components "$component" "$flags"
}

function atmos-get-stack-component-var(){
    local usage component varname kind;
    usage='
    Usage: atmos-get-stack-component-var <component> <varname> [kind: defaults to "terraform"]

    This function will return the value of the specified variable in the specified component of any stack
    that atmos can associate with it.
    '
    component=${1?"$usage"}
    varname=${2?"$usage"}
    kind=${3:-terraform}

    local clean filter query;
    clean="del( .* | select( .components.$kind.* == null ) )"
    filter="pick([\"$varname\"])"
    query="$clean | .*.components.$kind.*.vars |= $filter"
    atmos-describe-stack-component "$component" --sections=vars | yq "$query"
}

function atmos-list-component-directories(){
    local usage component_pattern base_folder;
    # shellcheck disable=SC2016
    usage='
    Usage: atmos-list-component-directories <component_pattern> [base_folder: defaults to $ATMOS_BASE_PATH/components/terraform]

    This function will return a list of directories, comma-delimitted, that match a grep regex pattern.
    '

    component_pattern=${1?"$usage"}
    base_folder=${2:-$ATMOS_BASE_PATH/components/terraform}

    pushd "$base_folder" || return 1 > /dev/null
    # shellcheck disable=SC2035
    find * -type d | grep "$component_pattern" | paste -sd ","
    popd || return 1 > /dev/null
}

function atmos-describe-component(){
    local usage component stack filter;
    usage='
    Usage: atmos-describe-component <component> [stack: defaults to ""] [filter: defaults to "."]

    This function will return the description of the specified component of any stack
    that atmos can associate with it.
    '
    component=${1?"$usage"}
    stack=${2:-}
    filter=${3:-.}

    atmos-describe-stack-component "$component" --sections=none
}