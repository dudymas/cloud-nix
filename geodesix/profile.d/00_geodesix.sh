# shellcheck shell=bash

if [ -n "$OVERRIDE_SHELL_VARS" ] ; then
    unset GEODESIC_LOCALHOST
    unset GEODESIC_WORKDIR
    unset GEODESIC_HOST_CWD
    unset ATMOS_BASE_PATH
    unset ATMOS_CLI_CONFIG_PATH
fi

if [ -z "$GEODESIC_NAMESPACE" ] ; then
    echo "GEODESIC_NAMESPACE is not set. You should set this to make sure awscli works properly."
elif [[ "$GEODESIC_NAMESPACE" = "__YOUR_NAMESPACE__" ]] ; then
    echo "GEODESIC_NAMESPACE is set to the default '__YOUR_NAMESPACE__'."
    echo "Please edit .envrc or export a new value before loading geodesix."
fi

# takes precedence in geodesic to set up the environment
export GEODESIC_LOCALHOST=${GEODESIC_LOCALHOST:-$HOME}
export GEODESIC_WORKDIR=${GEODESIC_WORKDIR:-$PWD}
export GEODESIC_HOST_CWD=${GEODESIC_HOST_CWD:-$PWD}
export ATMOS_BASE_PATH=${ATMOS_BASE_PATH:-$PWD}
export ATMOS_CLI_CONFIG_PATH=${ATMOS_CLI_CONFIG_PATH:-$PWD}
export DOCKER_IMAGE=${DOCKER_IMAGE:-$GEODESIC_NAMESPACE}
export DOCKER_IMAGE=${DOCKER_IMAGE:-$geodesix}
export AWS_PROFILE=${AWS_PROFILE:-${GEODESIC_NAMESPACE}-core-gbl-identity}

AWS_CONFIG_DIR=$GEODESIC_WORKDIR/rootfs/etc/aws-config

# Test if rootfs has aws-config-saml and update AWS_CONFIG_FILE if so
if [[ -f ${AWS_CONFIG_DIR}/aws-config-saml ]]; then
  export AWS_CONFIG_FILE=${AWS_CONFIG_DIR}/aws-config-saml
fi
