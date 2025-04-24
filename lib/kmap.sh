###############
# Lib: KMAP
# Load aliases.
###############

[[ -n "${_KMAP_INCLUDED:-}" ]] && return
readonly _KMAP_INCLUDED=1

################
# Load user-defined aliases from external file into KMAP.
# Globals:
#   KMAP_FILE
# Arguments:
#   None
# Outputs:
#   None
################
kmap::load::custom() {
  local config_file="${KMAP_FILE:-"${HOME}/.kmap.custom"}"
  [[ -f "${config_file}" ]] || return

  while IFS='=' read -r key val; do
    [[ "${key}" =~ ^#.*$ || -z "${key}" ]] && continue
    KMAP["${key}"]="${val}"
  done <"${config_file}"
}

################
# Variables defined below contain the built-in aliases.
################
ALL="ingressclass,ing,all,sc,pv,pvc,cm,secret"
declare -A KMAP=(
  # special
  ["w"]=" "

  # custom shortcuts
  ["#all"]="get node,ns,${ALL} -o wide --all-namespaces"
  ["#def"]="get ${ALL} -o wide --namespace default"
  ["#ks"]="get ${ALL} -o wide --namespace kube-system"
  ["#n"]="get ${ALL} -o wide --namespace"

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
  ["c"]="create"
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
  ["l"]="logs"
  ["lab"]="label"
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
  ["t"]="top"
  ["tai"]="taint"
  ["top"]="top"
  ["u"]="update"
  ["unc"]="uncordon"
  ["upd"]="update"
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
