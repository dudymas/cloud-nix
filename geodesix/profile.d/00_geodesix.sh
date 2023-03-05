# takes precedence in geodesic to set up the environment
export GEODESIC_LOCALHOST=$HOME
export GEODESIC_WORKDIR=$PWD
export GEODESIC_HOST_CWD=$PWD
export ATMOS_BASE_PATH=$PWD
export ATMOS_CLI_CONFIG_PATH=$PWD
export DOCKER_IMAGE=${DOCKER_IMAGE:-$GEODESIC_NAMESPACE}
export DOCKER_IMAGE=${DOCKER_IMAGE:-$geodesix}
export AWS_PROFILE=${GEODESIC_NAMESPACE}-core-gbl-identity
