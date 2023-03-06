# takes precedence in geodesic to set up the environment
export GEODESIC_LOCALHOST=$HOME
export GEODESIC_WORKDIR=$PWD
export GEODESIC_HOST_CWD=$PWD
export ATMOS_BASE_PATH=$PWD
export ATMOS_CLI_CONFIG_PATH=$PWD
export DOCKER_IMAGE=${DOCKER_IMAGE:-$GEODESIC_NAMESPACE}
export DOCKER_IMAGE=${DOCKER_IMAGE:-$geodesix}
export AWS_PROFILE=${AWS_PROFILE:-${GEODESIC_NAMESPACE}-core-gbl-identity}

AWS_CONFIG_DIR=$GEODESIC_WORKDIR/rootfs/etc/aws-config

# Test if rootfs has aws-config-saml and update AWS_CONFIG_FILE if so
if [[ -f ${AWS_CONFIG_DIR}/aws-config-saml ]]; then
  export AWS_CONFIG_FILE=${AWS_CONFIG_DIR}/aws-config-saml
fi
