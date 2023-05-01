# shellcheck shell=bash

function list-network-instances(){
    local usage default_network_profile;
    
    # shellcheck disable=SC2016
    usage='
    Usage: list-network-instances
    
    You can set the environment variable NETWORK_PROFILE to use a different network profile,
      otherwise it will default to "$GEODESIC_NAMESPACE-core-gbl-network-admin"
    '
    
    # Display usage if any arguments are passed
    if [ "$#" -gt 0 ]; then
      echo "$usage"
      return 1
    fi
    
    default_network_profile=$GEODESIC_NAMESPACE-core-gbl-network-admin
    
    # shellcheck disable=SC2016
    # Get a list of ec2 instances in the network account
    aws ec2 describe-instances \
      --profile "${NETWORK_PROFILE:-$default_network_profile}" \
      --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0],State.Name,PrivateIpAddress,PublicIpAddress]' \
      --output table
}

function connect-eks-over-ssm(){
    local usage cluster_name ssm_node_id ssm_local_port default_network_profile;
    
    # shellcheck disable=SC2016
    usage='
    Usage: connect-eks-over-ssm <cluster_name> <ssm_node_id> [ssm_local_port: defaults to 8001]
    
    Note, this assumes you have a network account profile, which defaults to "$GEODESIC_NAMESPACE-core-gbl-network-admin"
    If you would like to use a different profile for your network account, set the environment variable NETWORK_PROFILE
    '
    
    cluster_name=${1?"$usage"}
    ssm_node_id=${2?"$usage"}
    ssm_local_port=${3:-8001}
    default_network_profile="$GEODESIC_NAMESPACE-core-gbl-network-admin"

    # Check if a tmux session is already running and prompt to close it
    if tmux ls | grep "$cluster_name"; then
      echo "A tmux session for $cluster_name is already running. Do you want to close it and start a new session? (y/n)"
      read -r answer
      if [ "$answer" = "y" ]; then
        tmux kill-session -t "$cluster_name"
      else
        exit
      fi
    fi

    # Check that ssm_local_port is not already in use
    if lsof -i :"$ssm_local_port"; then
      echo "Port $ssm_local_port is already in use. Please choose a different port."
      exit
    fi

    local ssm_session_cmd ssm_session_params eks_endpoint;
    eks_endpoint=$(yq -r ".clusters[0].cluster.server" "$KUBECONFIG" | sed -e 's/https:\/\///')
    ssm_session_params="{\"portNumber\":[\"443\"],\"localPortNumber\":[\"$ssm_local_port\"],\"host\":[\"$eks_endpoint\"]}"
    ssm_session_cmd="start-session --target $ssm_node_id --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters '$ssm_session_params'"
    # Start a new tmux session and run the port forwarding command in the background
    tmux new-session -d -s "$cluster_name" "aws ssm $ssm_session_cmd --profile ${NETWORK_PROFILE:-$default_network_profile}" 

    # Wait for the port forwarding command to start
    sleep 2
    
    # If the port forwarding command is not running, retry it in the foreground
    if ! tmux ls | grep "$cluster_name"; then
      echo '
      Port forwarding command failed. Retrying in the foreground...
      '
      echo "aws ssm $ssm_session_cmd"
      aws ssm "$ssm_session_cmd"
    fi

    # Use yq to modify the configuration file to use the SSM port
    yq -i ".clusters[0].cluster.server |= \"https://localhost:$ssm_local_port\"" "$KUBECONFIG"
}
