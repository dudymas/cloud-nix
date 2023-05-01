# shellcheck shell=bash

function find-and-remove-terraform-lock-files(){
    local usage;
    usage='
    Usage: find-and-remove-terraform-lock-files
    
    Deletes all .terraform.lock.hcl files for components and their modules.
    This is helpful if you change architectures and need to re-initialize.
    Always assumes a "components" folder in the current directory.
    '
    
    # if any arguments are given, print usage and exit
    if [ $# -gt 0 ] ; then
        echo "$usage"
        return 1
    fi
    
    find components -type f -name ".terraform.lock.hcl" -exec rm -i {} \;
}
