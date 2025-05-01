#!/usr/bin/env bats

setup() {
  export DR=1
}

# -------------------------------------------------------------------
# Helper: assert that a given shorthand expands to the expected cmd
# Usage: assert_expansion "<shorthand>" "<expected prefix>"
# -------------------------------------------------------------------

assert_expansion() {
  local shorthand="$1"
  local expected="$2"

  # Test shorthand
  run "$BATS_TEST_DIRNAME"/../k $shorthand
  [ "$status" -eq 0 ]
  [[ "$output" == "kubectl $expected" ]] || \
    { echo "❌ shorthand '$shorthand' → expected 'kubectl $expected', got '$output'"; return 1; }

  # Test full command
  run "$BATS_TEST_DIRNAME"/../k $expected
  [ "$status" -eq 0 ]
  [[ "$output" == "kubectl $expected" ]] || \
    { echo "❌ full  '$expected'    → expected 'kubectl $expected', got '$output'"; return 1; }
}
