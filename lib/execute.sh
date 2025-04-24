###############
# Lib: Execute
# Execute the final `kubectl` command.
###############

[[ -n "${_EXECUTE_INCLUDED:-}" ]] && return
readonly _EXECUTE_INCLUDED=1

###############
# Execute the command based on arguments.
# Globals:
#   DR (dryrun)
# Arguments:
#   `kubectl` command
#   `k` arguments
# Outputs:
#   The result of the final command
###############
execute::command() {
  local cmd="$1"
  shift
  local args=("$@")

  # Dry-run
  if [[ -n "${DR:-}" && "${DR}" != "0" ]]; then
    command::print "${cmd}"
    return
  fi

  # Alternative watch
  if [[ "${args[0]}" == "w" ]]; then
    execute::watch "$cmd"
    return
  fi

  command::print "${cmd}"
  execute::default "$cmd"
}

###############
# Wrap the `kubectl` command into a `watch` command.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   The watched command
###############
execute::watch() {
  watch -n1 "${cmd}"
}

###############
# Runs the `kubectl` command.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   The result of the `kubectl` command
###############
execute::default() {
  eval "${cmd}"
}
