# shellcheck shell=bash

function find-and-update-yaml-files(){
    local usage search update;
    usage='
    Usage: find-and-update-yaml-files <search> <update>
    '
    search=${1?"$usage"}
    update=${2?"$usage"}
    # shellcheck disable=SC2035
    find * -type f -name "$search" -exec yq e "$update" -i {} \;
}

function grep-and-update-yaml-files(){
    local usage search update;
    usage='
    Usage: grep-and-update-yaml-files <search> <update>
    '
    search=${1?"$usage"}
    update=${2?"$usage"}
    grep "$search" -rl . | xargs -I {} yq e "$update" -i {}
}