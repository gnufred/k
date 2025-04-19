#!/usr/bin/env bash
#
# Refactored `k` using associative arrays for speed and maintainability.
# Original: https://gitlab.com/gnufred/k
# License: The Unlicense <https://unlicense.org>

################
# Requirements #
################
require_bash() {
  if (( BASH_VERSINFO[0] < 4 )); then
    echo "This script requires Bash 4 or higher." >&2
    exit 1
  fi
}
require_bash

###########
# Aliases #
###########
ALL="ingressclass,ing,all,sc,pv,pvc,cm,secret"

declare -A KMAP=(
  # special
  ["w"]=""

  # custom shortcuts
  ["#all"]="get node,ns,$ALL -o wide --all-namespaces"
  ["#def"]="get $ALL -o wide --namespace default"
  ["#ks"]="get $ALL -o wide --namespace kube-system"
  ["#n"]="get $ALL -o wide --namespace"

  # troubleshooting containers
  ["@alpine"]="run -it --rm alpine --image=alpine --restart=Never -- /bin/sh"
  ["@busybox"]="run -it --rm busybox --image=busybox --restart=Never -- /bin/sh"
  ["@netshoot"]="run -it --rm netshoot --image=nicolaka/netshoot --restart=Never -- /bin/bash"
  ["@ubuntu"]="run -it --rm ubuntu --image=ubuntu --restart=Never -- /bin/bash"

  # short options
  ["-n"]="--namespace"
  ["-s"]="--server"
  ["-v"]="--v"

  # kubectl options
  ["-c"]="--cluster"
  ["-p"]="--profile"
  ["-x"]="--context"
  ["--ag"]="--as-group"
  ["--au"]="--as-uid"
  ["--ca"]="--certificate-authority"
  ["--cc"]="--client-certificate"
  ["--cd"]="--cache-dir"
  ["--ck"]="--client-key"
  ["--cl"]="--cluster"
  ["--co"]="--context"
  ["--dc"]="--disable-compression"
  ["--drc"]="--dry-run=client"
  ["--drs"]="--dry-run=server"
  ["--ei"]="--external-ip"
  ["--istv"]="--insecure-skip-tls-verify"
  ["--kc"]="--kubeconfig"
  ["--lff"]="--log-flush-frequency"
  ["--msv"]="--match-server-version"
  ["--pa"]="--password"
  ["--po"]="--profile-output"
  ["--rt"]="--request-timeout"
  ["--sl"]="--show-labels"
  ["--tk"]="--token"
  ["--tsn"]="--tls-server-name"
  ["--un"]="--username"
  ["--us"]="--user"
  ["--vm"]="--vmodule"
  ["--wae"]="--warnings-as-errors"

  # subcommand options
  ["--ei"]="--external-ip"
  ["--sl"]="--show-labels"

  # output formats
  ["-J"]="-o json"
  ["-N"]="-o name"
  ["-S"]="--selector"
  ["-W"]="-o wide"
  ["-Y"]="-o yaml"

  # namespaces
  ["-A"]="--all-namespaces"
  ["ks"]="kube-system"

  # commands
  ["a"]="apply"
  ["a-r"]="api-resources"
  ["a-v"]="api-versions"
  ["ann"]="annotate"
  ["app"]="apply"
  ["asc"]="autoscale"
  ["att"]="attach"
  ["aut"]="auth"
  ["c-i"]="cluster-info"
  ["cer"]="certificate"
  ["com"]="completion"
  ["con"]="config"
  ["cor"]="cordon"
  ["cre"]="create"
  ["d"]="describe"
  ["deb"]="debug"
  ["del"]="delete"
  ["des"]="describe"
  ["dif"]="diff"
  ["dra"]="drain"
  ["e"]="edit"
  ["edi"]="edit"
  ["exe"]="exec"
  ["g"]="get"
  ["get"]="get"
  ["h"]="help"
  ["k"]="krew"
  ["kus"]="kustomize"
  ["lab"]="label"
  ["l"]="logs"
  ["log"]="logs"
  ["opt"]="options"
  ["p"]="patch"
  ["pat"]="patch"
  ["pf"]="port-forward"
  ["plu"]="plugin"
  ["pro"]="proxy"
  ["r"]="run"
  ["rep"]="replace"
  ["rol"]="rollout"
  ["sca"]="autoscale"
  ["set"]="set"
  ["tai"]="taint"
  ["t"]="top"
  ["top"]="top"
  ["unc"]="uncordon"
  ["ver"]="version"
  ["wai"]="wait"
  ["x"]="exec"
  ["xpl"]="explain"
  ["xpo"]="expose"

  # resources
  ["ap"]="apiservices.apiregistration.k8s.io"
  ["cc"]="csistoragecapacities.storage.k8s.io"
  ["cd"]="csidrivers.storage.k8s.io"
  ["ce"]="certificatesigningrequests.certificates.k8s.io"
  ["cj"]="cronjobs.batch"
  ["cm"]="configmaps"
  ["cn"]="csinodes.storage.k8s.io"
  ["cor"]="controllerrevisions.apps"
  ["cr"]="clusterroles.rbac.authorization.k8s.io"
  ["crb"]="clusterrolebindings.rbac.authorization.k8s.io"
  ["crd"]="customresourcedefinitions.apiextensions.k8s.io"
  ["cs"]="componentstatuses"
  ["de"]="deployment"
  ["ds"]="daemonset.apps"
  ["en"]="endpoints"
  ["es"]="endpointslices.discovery.k8s.io"
  ["ev"]="events"
  ["fs"]="flowschemas.flowcontrol.apiserver.k8s.io"
  ["hs"]="horizontalpodautoscalers.autoscaling"
  ["ic"]="ingressclasses.networking.k8s.io"
  ["in"]="ingresses.networking.k8s.io"
  ["jo"]="jobs.batch"
  ["le"]="leases.coordination.k8s.io"
  ["lr"]="limitranges"
  ["mh"]="mutatingwebhookconfigurations.admissionregistration.k8s.io"
  ["na"]="namespaces"
  ["no"]="nodes"
  ["np"]="networkpolicies.networking.k8s.io"
  ["pc"]="priorityclasses.scheduling.k8s.io"
  ["pd"]="poddisruptionbudgets.policy"
  ["pvc"]="persistentvolumeclaims"
  ["pl"]="prioritylevelconfigurations.flowcontrol.apiserver.k8s.io"
  ["po"]="pods"
  ["pt"]="podtemplates"
  ["pv"]="persistentvolumes"
  ["rb"]="rolebindings.rbac.authorization.k8s.io"
  ["rc"]="replicationcontrollers"
  ["ro"]="roles.rbac.authorization.k8s.io"
  ["rq"]="resourcequotas"
  ["rs"]="replicasets.apps"
  ["sa"]="serviceaccounts"
  ["sc"]="storageclasses.storage.k8s.io"
  ["se"]="secrets"
  ["ss"]="statefulsets.apps"
  ["sv"]="services"
  ["va"]="volumeattachments.storage.k8s.io"
  ["vh"]="validatingwebhookconfigurations.admissionregistration.k8s.io"

  # container shell helpers
  ["bash"]="-it -- /bin/bash"
  ["shell"]="-it -- /bin/sh"
)

###############
# Custom Kmap #
###############

# Load user-defined aliases from external file into KMAP
load_custom_kmap() {
  local config_file="$HOME/.kmap.custom"
  [[ -f "$config_file" ]] || return

  while IFS='=' read -r key val; do
    [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
    KMAP["$key"]="$val"
  done < "$config_file"
}
load_custom_kmap

###########
# Command #
###########

# Expand a single argument using KMAP, fallback to original
expand_arg() {
  local key="$1"
  local val="${KMAP[$key]}"
  [[ -n "$val" ]] && echo "$val" || echo "$key"
}

# Build the kubectl command string from all arguments
build_command() {
  CMD=""
  for arg in "$@"; do
    CMD+="$(expand_arg "$arg") "
  done
  CMD="kubectl ${CMD//  / }"
}

# Print the final command in bold to stderr
print_command() {
  if [[ -n "${K_DRYRUN:-}" && "${K_DRYRUN}" != "0" ]]; then
    echo "${CMD}"
  else
    >&2 echo -e "\033[1m${CMD}\033[0m"
  fi
}

########
# Exec #
########

# Execute the command when 'w' is first argument
execute_watch() {
  watch -n1 "${CMD}"
}

# Default execution of the command
execute_default() {
  eval "${CMD}" 
}

# Dispatch execution based on flags
execute_command() {
  [[ -n "${K_DRYRUN:-}" && "${K_DRYRUN}" != "0" ]] && exit 0

  if [[ "$1" == "w" ]]; then
    execute_watch
  else
    execute_default
  fi
}

##########
# Mutate #
##########
mutate_command () {
  printf ''
}

########
# Main #
########

main() {
  build_command "$@"
  mutate_command
  print_command
  execute_command "$@"
}

main "$@"

