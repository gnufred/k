[[ -n "${_MUTATE_INCLUDED:-}" ]] && return
readonly _MUTATE_INCLUDED=1

###############
# Change the `kubectl` command in :magical: ways!
# Globals:
#   None
# Arguments:
#   Unaliased `kubectl` command
# Outputs:
#   Mutated `kubectl` command
###############
mutate::command() {
  local cmd="$1"

  if [[ "${cmd}" == kubectl\ get\ events* ]]; then
    cmd="$(mutate::events::sort "$cmd")"
  fi

  echo "${cmd}"
}

###############
# Add the flags to sort result by last timestamp.
# Globals:
#   None
# Arguments:
#   Unaliased `kubectl` command
# Outputs:
#   Mutated `kubectl` command
###############
mutate::events::sort() {
  local cmd="$1"

  if [[ "${cmd}" != *"--sort-by"* ]]; then
    cmd+=" --sort-by='.lastTimestamp'"
  fi

  echo "${cmd}"
}

