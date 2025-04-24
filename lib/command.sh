[[ -n "${_COMMAND_INCLUDED:-}" ]] && return
readonly _COMMAND_INCLUDED=1

###############
# Unalias a `k` alias to its `kubectl` equivalent.
# Globals:
#   KMAP
# Arguments:
#   Alias
# Outputs:
#   Unaliased `kubectl` command
###############
command::args::parse() {
  local alias="$1"
  local original="${KMAP[$alias]}"
  [[ -n "${original}" ]] && echo "${original}" || echo "${alias}"
}

###############
# Build the kubectl command string from all arguments.
# Globals:
#   None
# Arguments:
#   User invoked arguments
# Outputs:
#   Full unaliased `kubectl` command
###############
command::build() {
  local args=("$@") cmd=""

  for a in "${args[@]}"; do
    cmd+="$(command::args::parse "${a}") "
  done

  echo "kubectl ${cmd}"
}

###############
# "Clean" a `kubectl` command.
# Globals:
#   None
# Arguments:
#   Build command
# Outputs:
#   "Cleaned" `kubectl` command
###############
command::clean() {
  shopt -s extglob

  # collapse any double‑spaces
  cmd="${cmd//+([ ])/ }"
  # remove all leading spaces
  cmd="${cmd#"${cmd%%[! ]*}"}"
  # remove the trailing space
  cmd="${cmd% }"

  echo "${cmd}"
}

###############
# Print the final command in to stderr.
# This makes the unaliased command available for the user to see
# Globals:
#   DR (dryrun)
# Arguments:
#   Command
# Outputs:
#   Command, to stderr
###############
command::print() {
  local cmd="$1"
  if [[ -n "${DR:-}" && "${DR}" != "0" ]]; then
    echo "${cmd}"
  else
    >&2 echo -e "\033[1m${cmd}\033[0m"
  fi
}

