# shellcheck shell=bash

function _update_cluster_config(){
	local new_config
	new_config=$(eks-update-kubeconfig set-kubeconfig "$@") || return
	export KUBECONFIG="$new_config"
	eks-update-kubeconfig "$@"
}
