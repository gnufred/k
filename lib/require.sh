[[ -n "${_REQUIRE_INCLUDED:-}" ]] && return
readonly _REQUIRE_INCLUDED=1

################
# Error and exit if script runs with Bash 3 or lower.
# Globals:
#   BASH_VERSINFO
# Arguments:
#   None
# Outputs:
#   Write error to stderr
################
require::bash() {
  if ((BASH_VERSINFO[0] < 4)); then
    echo "This script requires Bash 4 or higher." >&2
    exit 1
  fi
}

