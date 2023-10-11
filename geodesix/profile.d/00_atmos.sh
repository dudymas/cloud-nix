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

function atmos-add-component(){
  local usage component version type
  usage='
  Usage: atmos-add-component <component> <version> [terraform|helmfile]

  Adds a component to your repo and vendors it.
  '
  component=${1?"$usage"}
  version=${2?"$usage"}
  local type=${3:-terraform}
  local component_path=$(atmos describe config | yq '.base_path + "/" + '".components.${type}.base_path" )

  mkdir -p ${component_path}/${component}
  cat > ${component_path}/${component}/component.yaml <<EOF
# '${component}' component vendoring config

# 'component.yaml' in the component folder is processed by the 'atmos' commands
# 'atmos vendor pull -c ${component}' or 'atmos vendor pull --component ${component}'

apiVersion: atmos/v1
kind: ComponentVendorConfig
spec:
  source:
    # 'uri' supports all protocols (local files, Git, Mercurial, HTTP, HTTPS, Amazon S3, Google GCP),
    # and all URL and archive formats as described in https://github.com/hashicorp/go-getter
    # In 'uri', Golang templates are supported  https://pkg.go.dev/text/template
    # If 'version' is provided, {{ .Version }} will be replaced with the 'version' value before pulling the files from 'uri'
    uri: github.com/cloudposse/terraform-aws-components.git//modules/${component}?ref={{ .Version }}
    version: ${version}
    # Only include the files that match the 'included_paths' patterns
    # If 'included_paths' is not specified, all files will be matched except those that match the patterns from 'excluded_paths'
    # 'included_paths' support POSIX-style Globs for file names/paths (double-star `**` is supported)
    # https://en.wikipedia.org/wiki/Glob_(programming)
    # https://github.com/bmatcuk/doublestar#patterns
    included_paths:
      - "**/**"
    # Exclude the files that match any of the 'excluded_paths' patterns
    # Note that we are excluding 'context.tf' since a newer version of it will be downloaded using 'mixins'
    # 'excluded_paths' support POSIX-style Globs for file names/paths (double-star `**` is supported)
    excluded_paths: []
EOF
  atmos vendor pull -c ${component}
}
