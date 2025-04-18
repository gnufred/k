#!/usr/bin/env bats

setup() {
  export K_DRYRUN=1
  export HOME="/tmp"
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
  [[ "$output" == "kubectl $expected"* ]] || \
    { echo "❌ shorthand '$shorthand' → expected 'kubectl $expected', got '$output'"; return 1; }

  # Test full command
  run "$BATS_TEST_DIRNAME"/../k $expected
  [ "$status" -eq 0 ]
  [[ "$output" == "kubectl $expected"* ]] || \
    { echo "❌ full  '$expected'    → expected 'kubectl $expected', got '$output'"; return 1; }
}

@test "pod expansions" {
  assert_expansion "g po"         "get pods"
  assert_expansion "-n ks g po"   "--namespace kube-system get pods"
  assert_expansion "get po -W"    "get pods -o wide"
}

@test "get‐resource expansions" {
  assert_expansion "g no"          "get nodes"
  assert_expansion "g svc"         "get svc"
  assert_expansion "g cm"          "get configmaps"
}

@test "describe‐resource expansions" {
  assert_expansion "d po"          "describe pods"
  assert_expansion "des cm"        "describe configmaps"
  assert_expansion "d no"          "describe nodes"
}

@test "apply/delete expansions" {
  assert_expansion "a -f foo.yaml" "apply -f foo.yaml"
  assert_expansion "del po"        "delete pods"
}

@test "logs/exec expansions" {
  assert_expansion "l po"          "logs pods"
  assert_expansion "x po"          "exec pods"
}

@test "custom‑alias loading from HOME/.kmap.custom" {
  # Create a .kmap.custom in our fake HOME
  cat > "$HOME/.kmap.custom" <<EOF
foo=custom.resource.io
bar=barz.io/v1
EOF

  # Now test that 'foo' expands to the mapped value
  assert_expansion "get foo"  "get custom.resource.io"
  assert_expansion "g bar"    "get barz.io/v1"

  rm "$HOME/.kmap.custom"
}
