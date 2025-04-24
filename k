#!/bin/bash
#
# A `kubectl` wrapper for Infinite Monkeys randomly rewriting the Internet.
#
# Author: https://gnufred.pages.dev
# License: The Unlicense <https://unlicense.org>

###############
# Source libraries
###############
SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
readonly SCRIPT_DIR

libs=(require kmap command execute mutate)

for lib in "${libs[@]}"; do
  source "${SCRIPT_DIR}/lib/${lib}.sh"
done

###############
# Main application flow.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Unaliased `kubectl` command
#   Evaluated `kubectl` command
###############
main() {
  local cmd

  require::bash
  cmd="$(command::build "$@")"
  cmd="$(command::clean "${cmd}")"
  cmd="$(mutate::command "${cmd}")"
  execute::command "${cmd}" "$@"
}

kmap::load::custom
main "$@"
