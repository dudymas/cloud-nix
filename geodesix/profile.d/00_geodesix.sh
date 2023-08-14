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
export NAMESPACE=$GEODESIC_NAMESPACE

# takes precedence in geodesic to set up the environment
export GEODESIC_LOCALHOST=${GEODESIC_LOCALHOST:-$HOME}
export GEODESIC_WORKDIR=${GEODESIC_WORKDIR:-$PWD}
export GEODESIC_HOST_CWD=${GEODESIC_HOST_CWD:-$PWD}
export GEODESIC_CONFIG_HOME=${GEODESIC_CONFIG_HOME:-$GEODESIC_LOCALHOST/.config/geodesix}
export ATMOS_BASE_PATH=${ATMOS_BASE_PATH:-$PWD}
export ATMOS_CLI_CONFIG_PATH=${ATMOS_CLI_CONFIG_PATH:-$PWD}
export DOCKER_IMAGE=${DOCKER_IMAGE:-$GEODESIC_NAMESPACE}
export DOCKER_IMAGE=${DOCKER_IMAGE:-$geodesix}
export AWS_PROFILE=${AWS_PROFILE:-${GEODESIC_NAMESPACE}-core-gbl-identity}

AWS_CONFIG_DIR=$GEODESIC_WORKDIR/rootfs/etc/aws-config
PATH=$GEODESIC_WORKDIR/rootfs/usr/local/bin:$PATH

# We should just loop over saml, local, and teams to look for AWS_CONFIG_FILE
for config in saml local teams; do
  if [[ -f ${AWS_CONFIG_DIR}/aws-config-${config} ]]; then
    export AWS_CONFIG_FILE=${AWS_CONFIG_DIR}/aws-config-${config}
    break
  fi
done

# Set the KUBECONFIG environment variable to the modified Kubernetes configuration file
export KUBECONFIG_DIR=${KUBECONFIG_DIR:-$GEODESIC_CONFIG_HOME/kubectl}
export KUBECONFIG=$KUBECONFIG_DIR/${GEODESIC_NAMESPACE}.yaml
export EKS_KUBECONFIG_PATTERN=${EKS_KUBECONFIG_PATTERN:-$KUBECONFIG_DIR/${GEODESIC_NAMESPACE}.%s-%s.yaml}
mkdir -p "$(dirname "$KUBECONFIG")"

# Move our HISTFILE to be in the .config directory
export HISTFILE=$GEODESIC_CONFIG_HOME/history/${GEODESIC_NAMESPACE}.history
mkdir -p "$(dirname "$HISTFILE")"

# Chamber defaults
export CHAMBER_KMS_KEY_ALIAS=alias/aws/ssm
