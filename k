#!/usr/bin/env bash
#
# Refactored `k` using associative arrays for speed and maintainability.
# Original: https://gitlab.com/gnufred/k
# License: The Unlicense <https://unlicense.org>

# Require Bash 4+
if ((BASH_VERSINFO[0] < 4)); then
    echo "This script requires Bash 4 or higher." >&2
    exit 1
fi

ALL="ingressclass,ing,all,sc,pv,pvc,cm,secret"

# Define alias map
declare -A KMAP=(
  # Special
  ["w"]=""
  ["-Z"]=""

  # Custom shortcuts
  ["#all"]="get node,ns,$ALL -o wide --all-namespaces"
  ["#def"]="get $ALL -o wide --namespace default"
  ["#ks"]="get $ALL -o wide --namespace kube-system"
  ["#n"]="get $ALL -o wide --namespace"

  # Troubleshooting containers
  ["@alpine"]="run -it --rm alpine --image=alpine --restart=Never -- /bin/sh"
  ["@busybox"]="run -it --rm busybox --image=busybox --restart=Never -- /bin/sh"
  ["@netshoot"]="run -it --rm netshoot --image=nicolaka/netshoot --restart=Never -- /bin/bash"
  ["@ubuntu"]="run -it --rm ubuntu --image=ubuntu --restart=Never -- /bin/bash"

  # Short options
  ["-n"]="--namespace"
  ["-v"]="--v"
  ["-s"]="--server"

  # kubectl options
  ["--ag"]="--as-group"
  ["--au"]="--as-uid"
  ["--ca"]="--certificate-authority"
  ["--cc"]="--client-certificate"
  ["--cd"]="--cache-dir"
  ["--ck"]="--client-key"
  ["--cl"]="--cluster"
  ["--co"]="--context"
  ["-x"]="--context"
  ["--dc"]="--disable-compression"
  ["--drc"]="--dry-run=client"
  ["--drs"]="--dry-run=server"
  ["--istv"]="--insecure-skip-tls-verify"
  ["--kc"]="--kubeconfig"
  ["--lff"]="--log-flush-frequency"
  ["--msv"]="--match-server-version"
  ["--pa"]="--password"
  ["--po"]="--profile-output"
  ["--rt"]="--request-timeout"
  ["--tk"]="--token"
  ["--tsn"]="--tls-server-name"
  ["--un"]="--username"
  ["--us"]="--user"
  ["--vm"]="--vmodule"
  ["--wae"]="--warnings-as-errors"
  ["-c"]="--cluster"
  ["-p"]="--profile"

  # Subcommand options
  ["--ei"]="--external-ip"
  ["--sl"]="--show-labels"

  # Output formats
  ["-Y"]="-o yaml"
  ["-J"]="-o json"
  ["-W"]="-o wide"
  ["-N"]="-o name"
  ["-S"]="--selector"

  # Namespaces
  ["-A"]="--all-namespaces"
  ["ks"]="kube-system"

  # Commands
  ["a-r"]="api-resources"
  ["a-v"]="api-versions"
  ["ann"]="annotate"
  ["a"]="apply"
  ["app"]="apply"
  ["asc"]="autoscale"
  ["att"]="attach"
  ["aut"]="auth"
  ["sca"]="autoscale"
  ["c-i"]="cluster-info"
  ["cer"]="certificate"
  ["com"]="completion"
  ["con"]="config"
  ["cor"]="cordon"
  ["cre"]="create"
  ["deb"]="debug"
  ["del"]="delete"
  ["d"]="describe"
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
  ["run"]="run"
  ["rep"]="replace"
  ["rol"]="rollout"
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

  # Resources
  ["ap"]="apiservices.apiregistration.k8s.io"
  ["cc"]="csistoragecapacities.storage.k8s.io"
  ["cd"]="csidrivers.storage.k8s.io"
  ["crb"]="clusterrolebindings.rbac.authorization.k8s.io"
  ["ce"]="certificatesigningrequests.certificates.k8s.io"
  ["cj"]="cronjobs.batch"
  ["cm"]="configmaps"
  ["cn"]="csinodes.storage.k8s.io"
  ["cor"]="controllerrevisions.apps"
  ["cr"]="clusterroles.rbac.authorization.k8s.io"
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
  ["pvc"]="persistentvolumeclaims"
  ["pc"]="priorityclasses.scheduling.k8s.io"
  ["pd"]="poddisruptionbudgets.policy"
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

  # Container shell helpers
  ["shell"]="-it -- /bin/sh"
  ["bash"]="-it -- /bin/bash"
)

# Load external aliases into KMAP
load_custom_kmap() {
  local config_file="$HOME/.kmap.custom"
  [[ -f "$config_file" ]] || return

  while IFS='=' read -r key val; do
    # skip comments and blank lines
    [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
    KMAP["$key"]="$val"
  done < "$config_file"
}

load_custom_kmap  # load $HOME/.kmap.custom

expand() {
  local val="${KMAP[$1]}"
  [[ -n "$val" ]] && echo "$val" || echo "$1"
}

CMD=""
for A in "$@"; do
  CMD+="$(expand "$A") "
done

CMD="kubectl $CMD"
CMD=$(echo "$CMD" | sed 's/  */ /g')  # clean multiple spaces
>&2 echo -e "\033[1m$CMD\033[0m"

# Execute
if [[ "$1" == "w" ]]; then
  watch -n1 "$CMD"
elif [[ "${@: -1}" == "-Z" ]]; then
  eval "$CMD" | yq eval 'del(.metadata.creationTimestamp, .metadata.resourceVersion, .metadata.uid, .metadata.selfLink, .status)'
else
  eval "$CMD"
fi

